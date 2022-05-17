Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D22FC52A6C9
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 17:34:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348307AbiEQPec (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 11:34:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232929AbiEQPea (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 11:34:30 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3856440E7D;
        Tue, 17 May 2022 08:34:29 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HFHiHO029950;
        Tue, 17 May 2022 15:34:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=3N4OHjCBLTRes+QUFJLrXFM0igqq5oNDfD1rOss6h1M=;
 b=CmkUan5NR6mW3LZZ3lvS5ctY90b1IXf6cpgQ7YXe8gO2aWRJ2Y//yuJ86uQoQei7jLuk
 tckMrbbJfWmIZufYnVvklHebCwmy5gHNzlLyFGIOFRR7wMFRTqiJTBsxfSL9id350lhr
 /Na13zyYVJYoG8cPt9gjixNGzqMAtSzQsHzpqayByAKrm4XhDHr8jwQR3rg9r7rn+xzV
 OqRTDVUFAyeZpaDeL17YIY/YHKHbJvz1+ZsZ1NK5y5wtit+ds/1N0XwjjddPZut6t8Tu
 f+Ui7E8OGqvqYEObBHg9AEsx6xScmySg6UEkYyaO/N2SazbNDQlMnY0jKshHCJr3mAuC kQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g4e7k0k37-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 15:34:28 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24HFIdbB032524;
        Tue, 17 May 2022 15:34:28 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g4e7k0k1m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 15:34:27 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24HFRu9m031127;
        Tue, 17 May 2022 15:34:25 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 3g23pjcek5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 15:34:25 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24HFKWnF54002078
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 15:20:32 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 91D50A405B;
        Tue, 17 May 2022 15:34:22 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 43914A4054;
        Tue, 17 May 2022 15:34:22 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.56.72])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 17 May 2022 15:34:22 +0000 (GMT)
Message-ID: <64bc74c9170418c3b7c93834cbb425e0612ac4ad.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v2 3/4] s390x: Test effect of storage
 keys on some more instructions
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Date:   Tue, 17 May 2022 17:34:21 +0200
In-Reply-To: <20220517155407.693c600f@p-imbrenda>
References: <20220517115607.3252157-1-scgl@linux.ibm.com>
         <20220517115607.3252157-4-scgl@linux.ibm.com>
         <20220517155407.693c600f@p-imbrenda>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: oLXpRRnMELiQwsnou6PlA3iQZto88ecD
X-Proofpoint-ORIG-GUID: H2H6FUodyz7Gahxp5Hz2gXBexSZ1DbUz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-17_03,2022-05-17_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 lowpriorityscore=0 bulkscore=0 phishscore=0 spamscore=0 adultscore=0
 clxscore=1015 suspectscore=0 mlxlogscore=999 mlxscore=0 impostorscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205170095
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-05-17 at 15:54 +0200, Claudio Imbrenda wrote:
> On Tue, 17 May 2022 13:56:06 +0200
> Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:
> 
> > Test correctness of some instructions handled by user space instead of
> > KVM with regards to storage keys.
> > Test success and error conditions, including coverage of storage and
> > fetch protection override.
> > 
> > Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> > ---
> >  s390x/skey.c        | 285 ++++++++++++++++++++++++++++++++++++++++++++
> >  s390x/unittests.cfg |   1 +
> >  2 files changed, 286 insertions(+)
> > 
> > diff --git a/s390x/skey.c b/s390x/skey.c
> > index 19fa5721..60ae8158 100644
> > --- a/s390x/skey.c
> > +++ b/s390x/skey.c
> > @@ -12,6 +12,7 @@
> >  #include <asm/asm-offsets.h>
> >  #include <asm/interrupt.h>
> >  #include <vmalloc.h>
> > +#include <css.h>
> >  #include <asm/page.h>
> >  #include <asm/facility.h>
> >  #include <asm/mem.h>
> > @@ -284,6 +285,115 @@ static void test_store_cpu_address(void)
> >  	report_prefix_pop();
> >  }
> >  
> > +/*
> > + * Perform CHANNEL SUBSYSTEM CALL (CHSC)  instruction while temporarily executing
> > + * with access key 1.
> > + */
> > +static unsigned int chsc_key_1(void *comm_block)
> > +{
> > +	uint32_t program_mask;
> > +
> > +	asm volatile (
> > +		"spka	0x10\n\t"
> > +		".insn	rre,0xb25f0000,%[comm_block],0\n\t"
> > +		"spka	0\n\t"
> > +		"ipm	%[program_mask]\n"
> > +		: [program_mask] "=d" (program_mask)
> > +		: [comm_block] "d" (comm_block)
> > +		: "memory"
> > +	);
> > +	return program_mask >> 28;
> > +}
> > +
> > +static const char chsc_msg[] = "Performed store-channel-subsystem-characteristics";
> > +static void init_comm_block(uint16_t *comm_block)
> > +{
> > +	memset(comm_block, 0, PAGE_SIZE);
> > +	/* store-channel-subsystem-characteristics command */
> > +	comm_block[0] = 0x10;
> > +	comm_block[1] = 0x10;
> > +	comm_block[9] = 0;
> > +}
> > +
> > +static void test_channel_subsystem_call(void)
> > +{
> > +	uint16_t *comm_block = (uint16_t *)&pagebuf;
> > +	unsigned int cc;
> > +
> > +	report_prefix_push("CHANNEL SUBSYSTEM CALL");
> > +
> > +	report_prefix_push("zero key");
> > +	init_comm_block(comm_block);
> > +	set_storage_key(comm_block, 0x10, 0);
> > +	asm volatile (
> > +		".insn	rre,0xb25f0000,%[comm_block],0\n\t"
> > +		"ipm	%[cc]\n"
> > +		: [cc] "=d" (cc)
> > +		: [comm_block] "d" (comm_block)
> > +		: "memory"
> > +	);
> > +	cc = cc >> 28;
> > +	report(cc == 0 && comm_block[9], chsc_msg);
> > +	report_prefix_pop();
> > +
> > +	report_prefix_push("matching key");
> > +	init_comm_block(comm_block);
> > +	set_storage_key(comm_block, 0x10, 0);
> > +	cc = chsc_key_1(comm_block);
> > +	report(cc == 0 && comm_block[9], chsc_msg);
> > +	report_prefix_pop();
> > +
> > +	report_prefix_push("mismatching key");
> > +
> > +	report_prefix_push("no fetch protection");
> > +	init_comm_block(comm_block);
> > +	set_storage_key(comm_block, 0x20, 0);
> > +	expect_pgm_int();
> > +	chsc_key_1(comm_block);
> > +	check_key_prot_exc(ACC_UPDATE, PROT_STORE);
> 
> I wonder if ACC_UPDATE is really needed here? you should clearly never
> get a read error, right?

Maybe the naming isn't great, the first argument specifies the access
if it weren't for protection, not the access actually taking place.
If a read is indicated, that will cause a test failure.
You could use ACC_STORE, but that would be misleading, because it does
do a fetch.
> 
> > +	report_prefix_pop();
> > +
> > +	report_prefix_push("fetch protection");
> > +	init_comm_block(comm_block);
> > +	set_storage_key(comm_block, 0x28, 0);
> > +	expect_pgm_int();
> > +	chsc_key_1(comm_block);
> > +	check_key_prot_exc(ACC_UPDATE, PROT_FETCH_STORE);
> 
> and here, I guess you would wait for a read error? or is it actually
> defined as unpredictable?

Unpredictable, kvm and LPAR do different things IIRC, that's why I had
the report_info.
> 
> (same for all ACC_UPDATE below)

[...]
> >  
> > +/*
> > + * Perform MODIFY SUBCHANNEL (MSCH) instruction while temporarily executing
> > + * with access key 1.
> > + */
> > +static uint32_t modify_subchannel_key_1(uint32_t sid, struct schib *schib)
> > +{
> > +	uint32_t program_mask;
> > +
> > +/*
> > + * gcc 12.0.1 warns if schib is < 4k.
> > + * We need such addresses to test fetch protection override.
> > + */
> > +#pragma GCC diagnostic push
> > +#pragma GCC diagnostic ignored "-Warray-bounds"
> 
> I really dislike these pragmas
> 
> can we find a nicer way?

I'll do what ever we decide on in the other patch series.
> 
> > +	asm volatile (
> > +		"lr %%r1,%[sid]\n\t"
> > +		"spka	0x10\n\t"
> > +		"msch	%[schib]\n\t"
> > +		"spka	0\n\t"
> > +		"ipm	%[program_mask]\n"
> > +		: [program_mask] "=d" (program_mask)
> > +		: [sid] "d" (sid),
> > +		  [schib] "Q" (*schib)
> > +		: "%r1"
> > +	);
> > +#pragma GCC diagnostic pop
> > +	return program_mask >> 28;
> > +}
> > +
[...]

Thanks for the review, also for the other patch.
