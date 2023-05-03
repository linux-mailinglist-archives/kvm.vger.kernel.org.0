Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB30F6F5B70
	for <lists+kvm@lfdr.de>; Wed,  3 May 2023 17:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230302AbjECPnT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 May 2023 11:43:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbjECPnQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 May 2023 11:43:16 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70692619C
        for <kvm@vger.kernel.org>; Wed,  3 May 2023 08:43:15 -0700 (PDT)
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 343FalCn030388;
        Wed, 3 May 2023 15:43:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=vx3o0T33hx6rn8rXYVTmSp9kwUJlU+DzluCUpp2fUlE=;
 b=FrHL0lBA4tvYWBlgoR4bFnpBPwgwPlOFbyOBLcQr1wiKdUUyJlkVr2thLX3DrKbcuufJ
 ijB8X/618PQYVTFAnUkY33THOmEV16YM2HNb1x+7aPhP7BgFCITDyPGvVM1SWpzdiquH
 L3Z30WfN4Y76TXX6XER/OvJlMCWLMUiO/QFMnQA0Nwwdj0SfbFhdaCS5/5Y3kjHt0s6J
 eLax/ynzfjdymPYmfRurF2XWL5WHJn9QsuWcNrbNHlgW4KVZdBG90Jnsx34ogWIQtRHr
 yBowJvzVOa5YtWgJBo7GaWoeAtgePlMtBE4PUIjWRhcbkc4aV8JHB2RjLDDxcnBnH7Dm ig== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qbtdcr66y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 May 2023 15:43:06 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 343Fc14G003597;
        Wed, 3 May 2023 15:43:06 GMT
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qbtdcr66m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 May 2023 15:43:05 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 343BviWM027148;
        Wed, 3 May 2023 15:43:05 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([9.208.129.113])
        by ppma04wdc.us.ibm.com (PPS) with ESMTPS id 3q8tv7w4x6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 May 2023 15:43:05 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
        by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 343Fh4xY32375210
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 3 May 2023 15:43:04 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DFD0258058;
        Wed,  3 May 2023 15:43:03 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E578758059;
        Wed,  3 May 2023 15:43:02 +0000 (GMT)
Received: from lingrow.int.hansenpartnership.com (unknown [9.211.131.5])
        by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Wed,  3 May 2023 15:43:02 +0000 (GMT)
Message-ID: <35c08fdeb855d1666f10de4fc6d98164e2017d81.camel@linux.ibm.com>
Subject: Re: [ANNOUNCEMENT] COCONUT Secure VM Service Module for SEV-SNP
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     Dionna Amalie Glaze <dionnaglaze@google.com>,
        =?ISO-8859-1?Q?J=F6rg_R=F6del?= <jroedel@suse.de>
Cc:     Tom Lendacky <thomas.lendacky@amd.com>,
        Klaus Kiwi <kkiwi@redhat.com>, linux-coco@lists.linux.dev,
        kvm@vger.kernel.org, amd-sev-snp@lists.suse.com
Date:   Wed, 03 May 2023 11:43:01 -0400
In-Reply-To: <CAAH4kHa_mWSVrOdp-XvV9kd0fULQ_OOf4j8TMWJy6GhoZD5SEg@mail.gmail.com>
References: <ZBl4592947wC7WKI@suse.de>
         <4420d7e5-d05f-8c31-a0f2-587ebb7eaa20@amd.com> <ZFJTDtMK0QqXK5+E@suse.de>
         <CAAH4kHa_mWSVrOdp-XvV9kd0fULQ_OOf4j8TMWJy6GhoZD5SEg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: gUgu6-wL5ATaublN0RWaq6rpFy1KZrFN
X-Proofpoint-ORIG-GUID: xzts9BAt-jCenPpJgv2ySfxkQ_bbvSTh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-03_10,2023-05-03_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 bulkscore=0 clxscore=1011 lowpriorityscore=0 adultscore=0
 suspectscore=0 spamscore=0 mlxlogscore=643 phishscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2305030132
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2023-05-03 at 08:24 -0700, Dionna Amalie Glaze wrote:
> On Wed, May 3, 2023 at 5:27 AM Jörg Rödel <jroedel@suse.de> wrote:
[...]
> > If there is still a strong desire to have COCONUT with a TPM
> > (running at CPL-0) before CPL-3 support is usable, then I can live
> > with including code for that as a temporary solution. But linking
> > huge amounts of C code (like openssl or a tpm lib) into the SVSM
> > rust binary kind of contradicts the goals which made us using Rust
> > for project in the first place. That is why I only see this as a
> > temporary solution.
> > 
> > > Since we don't want to split resources or have competing
> > > projects, we are leaning towards moving our development resources
> > > over to the coconut-svsm project.
> > 
> 
> Not to throw a wrench in the works, but is it possible for us to have
> an RTMR protocol as a stop-gap between a fully paravirtualized vTPM
> and a fully internalized vTPM? The EFI protocol
> CC_MEASUREMENT_PROTOCOL is already standardized, and it can serve as
> a hardware-rooted integrity measure for a paravirtualized vTPM. This
> solution would further allow a TDX measured boot solution to be more
> thoroughly supported earlier, given that we'd need to have the RTMR
> event log replay logic implemented.

From our point of view, having a large set of existing open source
tools which speak the TPM protocol is the big benefit of the vTPM
approach.  Currently the partially closed source Amber attestation
service, which is designed as the recipient of the RTMR protocol, only
understands TDX (and SGX) attestation, so it would be more work than
simply implementing a RTMR approach to make it attach to this tool. 
There would also be the huge problem of how we replicate the quoting
enclave on SEV...

James

