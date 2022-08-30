Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3175A6718
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 17:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbiH3PQU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 11:16:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbiH3PQR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 11:16:17 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 392BAB5E6B;
        Tue, 30 Aug 2022 08:16:17 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27UE87lF028188;
        Tue, 30 Aug 2022 15:16:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=iHmHsycLOcDAHTv54jjfifJPr1DnD+ODozT0m3LRGrU=;
 b=ifUgiuFOT4E9iNGkTjUfRy5eqIkN/yGR08H2JVd0LZb/FwHYMVbYJpynaZ0/hkqZQhKr
 ZI2bfyWHWeYKLIF5e9P0weZ4046tiC5ASmbJlPz0q7P522+XCLKwZYyyg/p/QDDILweb
 tjH7KHFJmBu5pHUKbFPpgrrKuH4DZrHxAO7QWdz/9Vz1hPbvTUao7Az0ho3my0XA/u00
 dU6viwiEeuRvwnxO2vsBGO6rRSjY8POMSRb6mUrfbhSojy7nXHZoMoLvEpd99aHlkKv+
 cuRLWTisha4946D1fb4SBN9PnbkfIYMCTjt1W5ozE+sX+L29BW/nhLrvvudccOrHjPbR 8w== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j9knj2y17-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Aug 2022 15:16:16 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27UEpnmN002703;
        Tue, 30 Aug 2022 15:16:14 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3j7ahj3wya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Aug 2022 15:16:14 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27UFGBET30802296
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Aug 2022 15:16:11 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2DED2A405B;
        Tue, 30 Aug 2022 15:16:11 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EFD80A405F;
        Tue, 30 Aug 2022 15:16:10 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.3.250])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 30 Aug 2022 15:16:10 +0000 (GMT)
Message-ID: <4bb9026dee15e94f4643a36c7171fa1c8714bad2.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v6 1/2] s390x: Add specification
 exception test
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org
Date:   Tue, 30 Aug 2022 17:16:10 +0200
In-Reply-To: <166187009028.75997.13672950150134705250@t14-nrb>
References: <20220826161112.3786131-1-scgl@linux.ibm.com>
         <20220826161112.3786131-2-scgl@linux.ibm.com>
         <166187009028.75997.13672950150134705250@t14-nrb>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: TBsGjyu8l9ONP0E63p1Yx3ox6uf0pXha
X-Proofpoint-GUID: TBsGjyu8l9ONP0E63p1Yx3ox6uf0pXha
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-30_08,2022-08-30_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 lowpriorityscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 impostorscore=0 phishscore=0 spamscore=0 adultscore=0 clxscore=1015
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208300074
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-08-30 at 16:34 +0200, Nico Boehr wrote:
> Quoting Janis Schoetterl-Glausch (2022-08-26 18:11:11)
> > Generate specification exceptions and check that they occur.
> > 
> > Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> 
> Reviewed-by: Nico Boehr <nrb@linux.ibm.com>

Thanks
> 
> with minor nits below you may want to consider
> 
> > diff --git a/s390x/spec_ex.c b/s390x/spec_ex.c
> > new file mode 100644
> [...]
> > +static int bad_alignment(void)
> > +{
> > +       uint32_t words[5] __attribute__((aligned(16)));
> > +       uint32_t (*bad_aligned)[4] = (uint32_t (*)[4])&words[1];
> 
> Why not simply:
> 
> uint32_t *bad_aligned = &words[1];

This is a pointer to a word, the argument to lpq is a quadword.
Your way would probably work, especially since we don't actually want
the asm to do anything, but no harm in doing it the correct way.
> 
> > +
> > +       /* LOAD PAIR FROM QUADWORD (LPQ) requires quadword alignment */
> > +       asm volatile ("lpq %%r6,%[bad]"
> > +                     : : [bad] "T" (*bad_aligned)
> > +                     : "%r6", "%r7"
> > +       );
> > +       return 0;
> > +}
> > +
> > +static int not_even(void)
> > +{
> > +       uint64_t quad[2] __attribute__((aligned(16))) = {0};
> > +
> > +       asm volatile (".insn    rxy,0xe3000000008f,%%r7,%[quad]" /* lpq %%r7,%[quad] */
> 
> Here you use .insn above you use lpq - why?

The assembler will complain about the odd register number, but that is
intentional.
