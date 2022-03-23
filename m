Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE35A4E5420
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 15:19:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237105AbiCWOVS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 10:21:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244802AbiCWOVM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 10:21:12 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12A767C79B;
        Wed, 23 Mar 2022 07:19:40 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22NCfmKx006820;
        Wed, 23 Mar 2022 14:19:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=e9XJnMzlIjuTViPwa8QXuPGVzck1MXJXYNkUQTLUhZc=;
 b=akNjDXLGPS2XHBOAMDWneRWLyUJxIwMog1Wf/0PspWiO3ruJmaloKi7gl4/Q14Rn5TKr
 GDE62GyFAhHeVEKq+uVjH+CDSCOc1KR50rIuVNM0q2VIgtuWa/jbUOfhYfuluTEcAHKq
 CK5mcd3L6ZapDQCKx2hpTFQ8lA/u/L2Z77yNC3TmkuPD7XmaPB3U2VUtGl1SzymeCuBl
 twS1vV2KtAuF8/jBApOgKKFGY+4hHKl/F6xMylG7R2/YP/VztVXTAeIzLIoKbvYFWZaT
 ADu0Elj30FqHeeDqaXzVNxh3Cb9THCV9HHcA/5yTI7DIt4hUfA6Gkx0SynH/sRhtHX18 tw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f03sb2bbj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Mar 2022 14:19:39 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22NE7X3G005593;
        Wed, 23 Mar 2022 14:19:39 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f03sb2bav-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Mar 2022 14:19:39 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22NEHPGR030008;
        Wed, 23 Mar 2022 14:19:37 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3ew6t90r35-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Mar 2022 14:19:36 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22NEJXEX40173862
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Mar 2022 14:19:33 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BB57D52050;
        Wed, 23 Mar 2022 14:19:33 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.5.47])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 6E8125204F;
        Wed, 23 Mar 2022 14:19:33 +0000 (GMT)
Message-ID: <1d1fa70ec01e7a3284d997dc05272fe144288fa0.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v1 4/9] s390x: smp: add test for
 SIGP_STORE_ADTL_STATUS order
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, thuth@redhat.com, david@redhat.com,
        farman@linux.ibm.com
Date:   Wed, 23 Mar 2022 15:19:33 +0100
In-Reply-To: <20220321155900.77bd89d8@p-imbrenda>
References: <20220321101904.387640-1-nrb@linux.ibm.com>
         <20220321101904.387640-5-nrb@linux.ibm.com>
         <20220321155900.77bd89d8@p-imbrenda>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: axSXhAzJG3Mw9XDNXmQg9C7OtyonTYAj
X-Proofpoint-ORIG-GUID: r4kvGlm-KQLPZMuecUSThv78_Nwp-0wb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-23_07,2022-03-22_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 phishscore=0
 impostorscore=0 malwarescore=0 clxscore=1015 mlxscore=0 adultscore=0
 suspectscore=0 lowpriorityscore=0 mlxlogscore=999 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203230081
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-03-21 at 15:59 +0100, Claudio Imbrenda wrote:
> On Mon, 21 Mar 2022 11:18:59 +0100
> Nico Boehr <nrb@linux.ibm.com> wrote:
> > diff --git a/s390x/smp.c b/s390x/smp.c
> > index e5a16eb5a46a..5d3265f6be64 100644
> > --- a/s390x/smp.c
[...]
> > +/*
> > + * We keep two structs, one for comparing when we want to assert
> > it's not
> > + * touched.
> > + */
> > +static uint8_t adtl_status[2][4096]
> > __attribute__((aligned(4096)));
> 
> it's a little bit ugly. maybe define a struct, with small buffers
> inside
> for the vector and gs areas? that way we would not need ugly magic
> numbers below (see below)

OK, will do.

[...]
> > +static void restart_write_vector(void)
> > +{
> > +       uint8_t *vec_reg;
> > +       uint8_t *vec_reg_16_31 = &expected_vec_contents[16][0];
> 
> add a comment to explain that vlm only handles at most 16 registers
> at
> a time

OK will do.

> > +       int i;
> > +
> > +       for (i = 0; i < NUM_VEC_REGISTERS; i++) {
> > +               vec_reg = &expected_vec_contents[i][0];
> > +               memset(vec_reg, i, VEC_REGISTER_SIZE);
> > +       }
> 
> this way vector register 0 stays 0.
> either special case it (e.g. 16, or whatever), or put a magic value
> somewhere in every register

adtl_status is initalized with 0xff. Are you OK with i + 1 so we avoid
zero?

[...]
> > +static void test_store_adtl_status_vector(void)
> > +{
> > +       uint32_t status = -1;
> > +       struct psw psw;
> > +       int cc;
> > +
> > +       report_prefix_push("store additional status vector");
> > +
> > +       if (!test_facility(129)) {
> > +               report_skip("vector facility not installed");
> > +               goto out;
> > +       }
> > +
> > +       cpu_write_magic_to_vector_regs(1);
> > +       smp_cpu_stop(1);
> > +
> > +       memset(adtl_status, 0xff, sizeof(adtl_status));
> > +
> > +       cc = smp_sigp(1, SIGP_STORE_ADDITIONAL_STATUS,
> > +                 (unsigned long)adtl_status, &status);
> > +       report(!cc, "CC = 0");
> > +
> > +       report(!memcmp(adtl_status, expected_vec_contents,
> > sizeof(expected_vec_contents)),
> > +              "additional status contents match");
> 
> it would be interesting to check that nothing is stored past the end
> of
> the buffer.

I will add checks to ensure reserved fields are not modified.

> moreover, I think you should also explicitly test with lc_10, to make
> sure that works as well (no need to rerun the guest, just add another
> sigp call)

I will test vector with LC 0, 10, 11, 12 and guarded storage with LC 11
and 12.

[...]
> > +static void restart_write_gs_regs(void)
> > +{
> > +       const unsigned long gs_area = 0x2000000;
> > +       const unsigned long gsc = 25; /* align = 32 M, section size
> > = 512K */
> > +
> > +       ctl_set_bit(2, CTL2_GUARDED_STORAGE);
> > +
> > +       gs_cb.gsd = gs_area | gsc;
> > +       gs_cb.gssm = 0xfeedc0ffe;
> > +       gs_cb.gs_epl_a = (uint64_t) &gs_epl;
> > +
> > +       load_gs_cb(&gs_cb);
> > +
> > +       set_flag(1);
> > +
> > +       ctl_clear_bit(2, CTL2_GUARDED_STORAGE);
> 
> what happens when the function returns? is r14 set up properly? (or
> maybe we just don't care, since we are going to stop the CPU anyway?)

We have an endless loop in smp_cpu_setup_state. So r14 will point there
(verified with gdb).

In the end, I think we don't care. This is in contrast to the vector
test, where the epilogue will clean up the floating point regs.

[...]
> > +static void test_store_adtl_status_gs(void)
> > +{
> > +       const unsigned long adtl_status_lc_11 = 11;
> > +       uint32_t status = 0;
> > +       int cc;
> > +
> > +       report_prefix_push("store additional status guarded-
> > storage");
> > +
> > +       if (!test_facility(133)) {
> > +               report_skip("guarded-storage facility not
> > installed");
> > +               goto out;
> > +       }
> > +
> > +       cpu_write_to_gs_regs(1);
> > +       smp_cpu_stop(1);
> > +
> > +       memset(adtl_status, 0xff, sizeof(adtl_status));
> > +
> > +       cc = smp_sigp(1, SIGP_STORE_ADDITIONAL_STATUS,
> > +                 (unsigned long)adtl_status | adtl_status_lc_11,
> > &status);
> > +       report(!cc, "CC = 0");
> > +
> > +       report(!memcmp(&adtl_status[0][1024], &gs_cb,
> > sizeof(gs_cb)),
> 
> e.g. the 1024 is one of those "magic number" I mentioned above 

OK, fixed.

> 
> > +              "additional status contents match");
> 
> it would be interesting to test that nothing is stored after the end
> of
> the buffer (i.e. everything is still 0xff in the second half of the
> page)

Yes, done.

[...]
> > 
> > diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> > index 1600e714c8b9..2d0adc503917 100644
> > --- a/s390x/unittests.cfg
> > +++ b/s390x/unittests.cfg
> > @@ -77,6 +77,12 @@ extra_params=-name kvm-unit-test --uuid
> > 0fb84a86-727c-11ea-bc55-0242ac130003 -sm
> >  [smp]
> >  file = smp.elf
> >  smp = 2
> > +extra_params = -cpu host,gs=on,vx=on
> > +
> > +[smp-no-vec-no-gs]
> > +file = smp.elf
> > +smp = 2
> > +extra_params = -cpu host,gs=off,vx=off
> 
> using "host" will break TCG
> (and using "qemu" will break secure execution)
> 
> there are two possible solutions:
> 
> use "max" and deal with the warnings, or split each testcase in two,
> one using host cpu and "accel = kvm" and the other with "accel = tcg"
> and qemu cpu.

Uh, thanks for pointing out. I will split in accel = tcg and accel =
kvm.

> what should happen if only one of the two features is installed?
> should
> the buffer for the unavailable feature be stored with 0 or should it
> be
> left untouched? is it worth testing those scenarios?

The PoP specifies: "A facility’s registers are only
stored in the MCESA when the facility is installed."

Maybe I miss something, but it doesn't seem worth it. It would mean
adding yet another instance to the unittests.cfg. Since once needs to
provide the memory for the registers even when the facility isn't
there, there seems little risk for breaking something when we store if
the facility isn't there.
