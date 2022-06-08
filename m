Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC434543A16
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 19:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231501AbiFHRQp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 13:16:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230364AbiFHRQd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 13:16:33 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01C744147AA;
        Wed,  8 Jun 2022 10:03:30 -0700 (PDT)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 258Gtm2K001284;
        Wed, 8 Jun 2022 17:03:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=BsRP9RxNQfIsZ2jsO5UPfRYxPlYKtzsfmS+EJeTHLbA=;
 b=Sug0IxkvJqlQxdEt6mGPGB2WTZJmbZYB+bUY+jYgdBbj/iQAkKrLi5IbvUUFQLkLO7ik
 UzSUSjVGCllpf1T6W1EvWVI3ylDYJywfo/f6VIWXsDrHhdjlVn0c8L4/HOUpu8ouabZR
 f8i7uYyIKcP1kXro5V7xGfpNbJwDwGguAc88lbzEycPw5V7WoiGzhIpXvutLfUmtA3qC
 y5avTpFAPFjidcMGuxVpNj4bMYaI7SpBkTeTP/zwISr4EhqyOrhmeCSRDSiZ6gy2nciH
 j/e4vR88T3ZJcEPbMsIEfqMibqQdSAesaBYui2qQIdO17CgOgePLel68uWWD90JVoPmJ Dg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gjyqmg5gu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jun 2022 17:03:30 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 258Gu6a2002354;
        Wed, 8 Jun 2022 17:03:30 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gjyqmg5g2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jun 2022 17:03:30 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 258Gq4WT012827;
        Wed, 8 Jun 2022 17:03:27 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3gfxnhwrgp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jun 2022 17:03:27 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 258H3Oh852429160
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Jun 2022 17:03:24 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 832ED11C04C;
        Wed,  8 Jun 2022 17:03:24 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 38B2F11C04A;
        Wed,  8 Jun 2022 17:03:24 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.25.241])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  8 Jun 2022 17:03:24 +0000 (GMT)
Message-ID: <a6d1dfe0f9163650c8b3bb80065e12a1b190f97b.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v3 1/3] s390x: Test TEID values in
 storage key test
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Date:   Wed, 08 Jun 2022 19:03:23 +0200
In-Reply-To: <20220524170927.46fbd24a@p-imbrenda>
References: <20220523132406.1820550-1-scgl@linux.ibm.com>
         <20220523132406.1820550-2-scgl@linux.ibm.com>
         <20220524170927.46fbd24a@p-imbrenda>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: LrUJqA77Hs9odARBhDrhKCeH1iFamQ1Z
X-Proofpoint-ORIG-GUID: E4NSsCFhvJwwjiAZFO4IUryvtHJdRDGq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-08_05,2022-06-07_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 suspectscore=0 phishscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 clxscore=1015 impostorscore=0 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206080068
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-05-24 at 17:09 +0200, Claudio Imbrenda wrote:
> On Mon, 23 May 2022 15:24:04 +0200
> Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:
> 
> > On a protection exception, test that the Translation-Exception
> > Identification (TEID) values are correct given the circumstances of the
> > particular test.
> > The meaning of the TEID values is dependent on the installed
> > suppression-on-protection facility.
> > 
> > Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> > ---
> >  s390x/skey.c | 75 +++++++++++++++++++++++++++++++++++++++++++++++-----
> >  1 file changed, 69 insertions(+), 6 deletions(-)
> > 
> > diff --git a/s390x/skey.c b/s390x/skey.c
> > index 42bf598c..5e234cde 100644
> > --- a/s390x/skey.c
> > +++ b/s390x/skey.c
> > @@ -8,6 +8,7 @@

[...]

> > +		break;
> > +	case SOP_ENHANCED_2:
> > +		switch (teid_esop2_prot_code(teid)) {
> > +		case PROT_KEY:
> > +			access_code = teid.acc_exc_f_s;
> 
> is the f/s feature guaranteed to be present when we have esop2?

That's how I understand it. For esop1 the PoP explicitly states that
the facility is a prerequisite, for esop2 it doesn't.
> 
> can the f/s feature be present with esop1 or basic sop?

esop1: yes, basic: no.
The way I read it, in the case of esop1 the bits are only meaningful
for DAT and access list exceptions, i.e. when the TEID is not
unpredictable.
> 
> > +
> > +			switch (access_code) {
> > +			case 0:
> > +				report_pass("valid access code");
> > +				break;
> > +			case 1:
> > +			case 2:
> > +				report((access & access_code) && (prot & access_code),
> > +				       "valid access code");
> > +				break;
> > +			case 3:
> > +				/*
> > +				 * This is incorrect in that reserved values
> > +				 * should be ignored, but kvm should not return
> > +				 * a reserved value and having a test for that
> > +				 * is more valuable.
> > +				 */
> > +				report_fail("valid access code");
> > +				break;
> > +			}
> > +			/* fallthrough */
> > +		case PROT_KEY_LAP:
> > +			report_pass("valid protection code");
> > +			break;
> > +		default:
> > +			report_fail("valid protection code");
> > +		}
> > +		break;
> > +	}
> > +	report_prefix_pop();
> > +}
> > +

[...]
