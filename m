Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1104A7CC338
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 14:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343641AbjJQMcU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 08:32:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234647AbjJQMcT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 08:32:19 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B73995;
        Tue, 17 Oct 2023 05:32:17 -0700 (PDT)
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39HCA20r025050;
        Tue, 17 Oct 2023 12:32:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references :
 subject : cc : to : from : message-id : date; s=pp1;
 bh=3jYBblpQmTnyPbk5ecIa6Ffw4/vEZXpk2tAFD54T+AM=;
 b=p01rbc9+PHQJheDgRqv8j9uUTvySG2ZX/aoO/hjvc+ndL2v0vF5nMxqyLIQ7m3RJLZp3
 Ld7Ui2wM7RNP8KxbXP55JWHMInWTNYNzq4KNSHTkPR3nxEjaYTCIhA6A9x1IA+1dDR8l
 cPeUTMP750SlTBezEjz+KFO9NqSml7sjKzd4E+tJk0OxgSIOPKiCvBbgBAk87U9KaVn0
 OB10i+gGurvpVIvyCRInsz0D3fN7TEVZlE8Zk4FqJeAU+g+ucyo080331+7JH1RKiEj+
 zZlbIIp1IzmcJ6S3rI3weSSnYrr8io5TfmgGT/yNpUOO1Qc7sLA3NbYRbtbydrQQ0KuM 6A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tst1krmwd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Oct 2023 12:32:06 +0000
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39HCAO0x025750;
        Tue, 17 Oct 2023 12:32:06 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tst1krmut-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Oct 2023 12:32:05 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
        by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39HAq4qe026885;
        Tue, 17 Oct 2023 12:32:04 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3tr5as9485-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Oct 2023 12:32:04 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39HCW1Nh14156490
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Oct 2023 12:32:01 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AC66520040;
        Tue, 17 Oct 2023 12:32:01 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 05E9220043;
        Tue, 17 Oct 2023 12:32:01 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.66.53])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 17 Oct 2023 12:32:00 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <37a91515-38d9-420f-89e9-cf18ab1ef997@linux.ibm.com>
References: <20231011085635.1996346-1-nsg@linux.ibm.com> <20231011085635.1996346-6-nsg@linux.ibm.com> <fc59fb56-4848-4282-bec5-bdef40c817ff@linux.ibm.com> <58d8c91480041e3516837ec2d26562de656ea7b9.camel@linux.ibm.com> <37a91515-38d9-420f-89e9-cf18ab1ef997@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH 5/9] s390x: topology: Refine stsi header test
Cc:     David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Andrew Jones <andrew.jones@linux.dev>,
        Colton Lewis <coltonlewis@google.com>,
        Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Ricardo Koller <ricarkol@google.com>,
        Sean Christopherson <seanjc@google.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>
From:   Nico Boehr <nrb@linux.ibm.com>
Message-ID: <169754591970.81646.12090809106412524268@t14-nrb>
User-Agent: alot/0.8.1
Date:   Tue, 17 Oct 2023 14:31:59 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0meEgO7eMybKEVqACH-oWVBmCXb-QTjr
X-Proofpoint-ORIG-GUID: tUsUy22fE63dt6pj_rNtkN1ysabKdRHs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-16_13,2023-10-17_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 priorityscore=1501 bulkscore=0 lowpriorityscore=0 spamscore=0 phishscore=0
 clxscore=1015 mlxscore=0 adultscore=0 malwarescore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2310170105
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Janosch Frank (2023-10-11 13:22:03)
> On 10/11/23 13:19, Nina Schoetterl-Glausch wrote:
> > On Wed, 2023-10-11 at 13:16 +0200, Janosch Frank wrote:
> >> On 10/11/23 10:56, Nina Schoetterl-Glausch wrote:
> >>> Add checks for length field.
> >>> Also minor refactor.
> >>>
> >>> Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> >>> ---
> >>>    s390x/topology.c | 15 +++++++++------
> >>>    1 file changed, 9 insertions(+), 6 deletions(-)
> >>>
> >>> diff --git a/s390x/topology.c b/s390x/topology.c
> >>> index 5374582f..0ba57986 100644
> >>> --- a/s390x/topology.c
> >>> +++ b/s390x/topology.c
> >>> @@ -187,18 +187,22 @@ static void stsi_check_maxcpus(struct sysinfo_1=
5_1_x *info)
> >>>    }
> >>>   =20
> >>>    /*
> >>> - * stsi_check_mag
> >>> + * stsi_check_header
> >>>     * @info: Pointer to the stsi information
> >>> + * @sel2: stsi selector 2 value
> >>>     *
> >>>     * MAG field should match the architecture defined containers
> >>>     * when MNEST as returned by SCLP matches MNEST of the SYSIB.
> >>>     */
> >>> -static void stsi_check_mag(struct sysinfo_15_1_x *info)
> >>> +static void stsi_check_header(struct sysinfo_15_1_x *info, int sel2)
> >>>    {
> >>>     int i;
> >>>   =20
> >>> -   report_prefix_push("MAG");
> >>> +   report_prefix_push("Header");
> >>>   =20
> >>> +   report(IS_ALIGNED(info->length, 8), "Length %d multiple of 8", in=
fo->length);
> >>
> >> STSI 15 works on Words, not DWords, no?
> >> So we need to check length against 4, not 8.
> >=20
> > The header is 16 bytes.
> > Topology list entries are 8 or 16, so it must be a multiple of 8 at lea=
st.
>=20
> Fair enough

Since I had the same question, can we have a comment here?

This isn't perfect but good enough IMO:

/* PoP mandates 4-byte alignment, but header is 16 bytes, TLEs are 8 or 16 =
bytes, so check for 8 byte align */

Otherwise:

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
