Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90F094E9ABF
	for <lists+kvm@lfdr.de>; Mon, 28 Mar 2022 17:12:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244432AbiC1POb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Mar 2022 11:14:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244431AbiC1POC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Mar 2022 11:14:02 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D33460CCE;
        Mon, 28 Mar 2022 08:12:19 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22SF8ob2004421;
        Mon, 28 Mar 2022 15:12:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=7PrPlNCGXR2LA0VBNeuq9yp2OFaSKxLMh9HG1oVBWeE=;
 b=smeaPCb6dGjAYtZiXOSN040osAmfoF4C3pyS0WgcF60DcDCnAcOnRgXzZpTDzsrUJWxA
 D70nJELNFbMHhykROQjwQOj2bIlujWvaiFq6hTTHEn7NnGNlfPsNns+za/e0q8u57MwD
 uSPeIh6rGxv78wG2VaiGJgshVexJ4wEeZa65plYCYYfTFM4MX5Qn/GscyVSVUoyMnjwI
 r7Iu5+PkUKoSU577HpEX+iF008h26e2QnJEx7iT0wsxo0gSNYhdH8jPyn1OlZxkZnvsS
 pILYX65/CIkVh9NumcrY2SozPpQbmf8Pm0wF9IBQMX3eCWH5cmRmcB5IiPkXCfg/aj16 qw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f3dykt2tq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Mar 2022 15:12:18 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22SF9lKq010177;
        Mon, 28 Mar 2022 15:12:17 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f3dykt2t8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Mar 2022 15:12:17 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22SEvgAf025403;
        Mon, 28 Mar 2022 15:12:16 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3f1tf9c8a7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Mar 2022 15:12:16 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22SFCCbf43254058
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Mar 2022 15:12:12 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CF9BC4203F;
        Mon, 28 Mar 2022 15:12:12 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8344242042;
        Mon, 28 Mar 2022 15:12:12 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.10.159])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 28 Mar 2022 15:12:12 +0000 (GMT)
Message-ID: <c1b585cbd42cff9920488a74ee5a40ed0d5b13f8.camel@linux.ibm.com>
Subject: Re: [PATCH 2/2] s390x: add test for SIGP STORE_ADTL_STATUS order
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, thuth@redhat.com, david@redhat.com,
        farman@linux.ibm.com
Date:   Mon, 28 Mar 2022 17:12:12 +0200
In-Reply-To: <2fafa98b-e342-047a-3a94-cf4111bc7198@linux.ibm.com>
References: <20220328093048.869830-1-nrb@linux.ibm.com>
         <20220328093048.869830-3-nrb@linux.ibm.com>
         <2fafa98b-e342-047a-3a94-cf4111bc7198@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: SQLilvbPPwp61umNpQ0Ifj7XuxUzZdXP
X-Proofpoint-GUID: YGCJew7QzVpvvvLp4LBoQUZVfNvSyHgx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-28_06,2022-03-28_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 mlxscore=0 clxscore=1015 malwarescore=0 spamscore=0
 bulkscore=0 impostorscore=0 adultscore=0 suspectscore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203280087
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-03-28 at 13:54 +0200, Janosch Frank wrote:
> > diff --git a/s390x/adtl_status.c b/s390x/adtl_status.c
> > new file mode 100644
> > index 000000000000..7a2bd2b07804
> > --- /dev/null
> > +++ b/s390x/adtl_status.c
[...]
> > +struct mcesa_lc12 {
> > +       uint8_t vector_reg[0x200];            /* 0x000 */
> 
> Hrm we could do:
> __uint128_t vregs[32];
> 
> or:
> uint64_t vregs[16][2];
> 
> or leave it as it is.

No strong preference about the type. uint8_t makes it easy to check the
offsets.

> 
> > +       uint8_t reserved200[0x400 - 0x200];   /* 0x200 */
> > +       struct gs_cb gs_cb;                   /* 0x400 */
> > +       uint8_t reserved420[0x800 - 0x420];   /* 0x420 */
> > +       uint8_t reserved800[0x1000 - 0x800];  /* 0x800 */
> > +};
> 
> Do we have plans to use this struct in the future for other tests?

Maybe at some point if we add checks for machine check handling, but
right now we don't have the infrastructure in kvm-unit-tests to do that
I think.

> 
> > +
> > +static struct mcesa_lc12 adtl_status
> > __attribute__((aligned(4096)));
> > +
> > +#define NUM_VEC_REGISTERS 32
> > +#define VEC_REGISTER_SIZE 16
> 
> I'd shove that into lib/s390x/asm/float.h or create a vector.h as
> #define VEC_REGISTERS_NUM 32
> #define VEC_REGISTERS_SIZE 16
> 
> Most likely vector.h since we can do both int and float with vector
> regs.

OK, will do.

[...]
> > +
> > +static int have_adtl_status(void)
> 
> bool

Changed.

[...]
> > +static void test_store_adtl_status_unavail(void)
> > +{
> > +       uint32_t status = 0;
> > +       int cc;
> > +
> > +       report_prefix_push("store additional status unvailable");
> 
> unavailable

Thanks.

[...]
> > +static void restart_write_vector(void)
> > +{
> > +       uint8_t *vec_reg;
> > +       /* vlm handles at most 16 registers at a time */
> > +       uint8_t *vec_reg_16_31 = &expected_vec_contents[16][0];
> > +       int i;
> > +
> > +       for (i = 0; i < NUM_VEC_REGISTERS; i++) {
> > +               vec_reg = &expected_vec_contents[i][0];
> > +               /* i+1 to avoid zero content */
> > +               memset(vec_reg, i + 1, VEC_REGISTER_SIZE);
> > +       }
> > +
> > +       ctl_set_bit(0, CTL0_VECTOR);
> > +
> > +       asm volatile (
> > +               "       .machine z13\n"
> > +               "       vlm 0,15, %[vec_reg_0_15]\n"
> > +               "       vlm 16,31, %[vec_reg_16_31]\n"
> > +               :
> > +               : [vec_reg_0_15] "Q"(expected_vec_contents),
> > +                 [vec_reg_16_31] "Q"(*vec_reg_16_31)
> > +               : "v0", "v1", "v2", "v3", "v4", "v5", "v6", "v7",
> > "v8", "v9",
> > +                 "v10", "v11", "v12", "v13", "v14", "v15", "v16",
> > "v17", "v18",
> > +                 "v19", "v20", "v21", "v22", "v23", "v24", "v25",
> > "v26", "v27",
> > +                 "v28", "v29", "v30", "v31", "memory"
> 
> We change memory on a load?

To my understanding, this might be neccesary if expected_vec_contents
ends up in a register, but that won't happen, so I can remove it.

> 
> > +       );
> 
> We could also move vlm as a function to vector.h and do two calls.

I think that won't work because that function might clean its float
registers in the epilogue and hence destroy the contents. Except if you
have an idea on how to avoid that?

[...]
> > diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> > index 1600e714c8b9..2e65106fa140 100644
> > --- a/s390x/unittests.cfg
> > +++ b/s390x/unittests.cfg
> > @@ -78,6 +78,31 @@ extra_params=-name kvm-unit-test --uuid
> > 0fb84a86-727c-11ea-bc55-0242ac130003 -sm
> >   file = smp.elf
> >   smp = 2
> >   
> > +[adtl_status-kvm]
> 
> Hmmmmm (TM) I don't really want to mix - and _.
> Having spec_ex-sie.c is already bad enough.

Yes, thanks.

> 
> > +file = adtl_status.elf
> > +smp = 2
> > +accel = kvm
> > +extra_params = -cpu host,gs=on,vx=on
> > +
> > +[adtl_status-no-vec-no-gs-kvm]
> > +file = adtl_status.elf
> > +smp = 2
> > +accel = kvm
> > +extra_params = -cpu host,gs=off,vx=off
> > +
> > +[adtl_status-tcg]
> > +file = adtl_status.elf
> > +smp = 2
> > +accel = tcg
> > +# no guarded-storage support in tcg
> > +extra_params = -cpu qemu,vx=on
> > +
> > +[adtl_status-no-vec-no-gs-tcg]
> > +file = adtl_status.elf
> > +smp = 2
> > +accel = tcg
> > +extra_params = -cpu qemu,gs=off,vx=off
> > +
> 
> Are you trying to sort this in any way?
> Normally we put new entries at the EOF.

Oh, this was a leftover from when this was still part of the smp test,
moved to the end now.
