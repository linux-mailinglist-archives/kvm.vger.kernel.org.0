Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 110917C51C0
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 13:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234892AbjJKLVY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 07:21:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345956AbjJKLVH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 07:21:07 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17F2FD63;
        Wed, 11 Oct 2023 04:20:02 -0700 (PDT)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39BBHwUW032127;
        Wed, 11 Oct 2023 11:19:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=YDeyZnwhC2S9P5CIzfToDKKFccHWNdzEHubh46Jmw9I=;
 b=CcVjuZoS5aVPCgtewYhu4HLXfci/8i6nE2cNSlMCEkd9LdM6y2uQW1zONG0XYtixIHaS
 ph5iL8pimiLfDxNrITfQDNy9IDhwEutFtLcb+Zi4GoJx2SIRwKMzVG72A/92GMZv7jsI
 PlFjcVTM1fKKzyxokW/yQZVeYwfhc8ljIQ+h+r0eZ0rybUt2SCCOJaC1C0CbbiucOAm1
 mnfy28AhN6uYFCFkykkCCy/VW4l1cas4Xd30eljMaY1FWB1akbTOFhTh1HLiRYShM3Xl
 RVgpdkux0z1GqVxFuDAHTKNUHVaiye8S6XAo3+Jiuv3Vdg2HX1YXp2dj/D2EyleI/t0n nQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tntq0r29q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Oct 2023 11:19:56 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39BBI8fT000935;
        Wed, 11 Oct 2023 11:19:56 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tntq0r292-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Oct 2023 11:19:56 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39B8wIJ6025901;
        Wed, 11 Oct 2023 11:19:54 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3tkjnnfjtg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Oct 2023 11:19:54 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39BBJpi814156466
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Oct 2023 11:19:51 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 897DD2004E;
        Wed, 11 Oct 2023 11:19:51 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5537B20040;
        Wed, 11 Oct 2023 11:19:51 +0000 (GMT)
Received: from li-978a334c-2cba-11b2-a85c-a0743a31b510.ibm.com (unknown [9.152.224.238])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 11 Oct 2023 11:19:51 +0000 (GMT)
Message-ID: <58d8c91480041e3516837ec2d26562de656ea7b9.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH 5/9] s390x: topology: Refine stsi header
 test
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nico =?ISO-8859-1?Q?B=F6hr?= <nrb@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Andrew Jones <andrew.jones@linux.dev>,
        Colton Lewis <coltonlewis@google.com>,
        Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Ricardo Koller <ricarkol@google.com>,
        Sean Christopherson <seanjc@google.com>
Date:   Wed, 11 Oct 2023 13:19:50 +0200
In-Reply-To: <fc59fb56-4848-4282-bec5-bdef40c817ff@linux.ibm.com>
References: <20231011085635.1996346-1-nsg@linux.ibm.com>
         <20231011085635.1996346-6-nsg@linux.ibm.com>
         <fc59fb56-4848-4282-bec5-bdef40c817ff@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: O_MSEhA9f5z-dnNJvdBZjl59WDWV6RQV
X-Proofpoint-ORIG-GUID: -h94BCHrNA3GkmTLhOpNQQaoJLBuHhfv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-11_09,2023-10-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 impostorscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 spamscore=0 phishscore=0
 clxscore=1015 priorityscore=1501 lowpriorityscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2310110099
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2023-10-11 at 13:16 +0200, Janosch Frank wrote:
> On 10/11/23 10:56, Nina Schoetterl-Glausch wrote:
> > Add checks for length field.
> > Also minor refactor.
> >=20
> > Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> > ---
> >   s390x/topology.c | 15 +++++++++------
> >   1 file changed, 9 insertions(+), 6 deletions(-)
> >=20
> > diff --git a/s390x/topology.c b/s390x/topology.c
> > index 5374582f..0ba57986 100644
> > --- a/s390x/topology.c
> > +++ b/s390x/topology.c
> > @@ -187,18 +187,22 @@ static void stsi_check_maxcpus(struct sysinfo_15_=
1_x *info)
> >   }
> >  =20
> >   /*
> > - * stsi_check_mag
> > + * stsi_check_header
> >    * @info: Pointer to the stsi information
> > + * @sel2: stsi selector 2 value
> >    *
> >    * MAG field should match the architecture defined containers
> >    * when MNEST as returned by SCLP matches MNEST of the SYSIB.
> >    */
> > -static void stsi_check_mag(struct sysinfo_15_1_x *info)
> > +static void stsi_check_header(struct sysinfo_15_1_x *info, int sel2)
> >   {
> >   	int i;
> >  =20
> > -	report_prefix_push("MAG");
> > +	report_prefix_push("Header");
> >  =20
> > +	report(IS_ALIGNED(info->length, 8), "Length %d multiple of 8", info->=
length);
>=20
> STSI 15 works on Words, not DWords, no?
> So we need to check length against 4, not 8.

The header is 16 bytes.
Topology list entries are 8 or 16, so it must be a multiple of 8 at least.

>=20
> > +	report(info->length < PAGE_SIZE, "Length %d in bounds", info->length)=
;
> > +	report(sel2 =3D=3D info->mnest, "Valid mnest");
> >   	stsi_check_maxcpus(info);
> >  =20
> >   	/*
> > @@ -326,7 +330,6 @@ static int stsi_get_sysib(struct sysinfo_15_1_x *in=
fo, int sel2)
> >  =20
> >   	if (max_nested_lvl >=3D sel2) {
> >   		report(!ret, "Valid instruction");
> > -		report(sel2 =3D=3D info->mnest, "Valid mnest");
> >   	} else {
> >   		report(ret, "Invalid instruction");
> >   	}
> > @@ -365,7 +368,7 @@ static void check_sysinfo_15_1_x(struct sysinfo_15_=
1_x *info, int sel2)
> >   		goto vertical;
> >   	}
> >  =20
> > -	stsi_check_mag(info);
> > +	stsi_check_header(info, sel2);
> >   	stsi_check_tle_coherency(info);
> >  =20
> >   vertical:
> > @@ -378,7 +381,7 @@ vertical:
> >   		goto end;
> >   	}
> >  =20
> > -	stsi_check_mag(info);
> > +	stsi_check_header(info, sel2);
> >   	stsi_check_tle_coherency(info);
> >   	report_prefix_pop();
> >  =20
>=20

