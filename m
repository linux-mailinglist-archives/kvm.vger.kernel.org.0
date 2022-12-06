Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A198164425C
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 12:45:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234271AbiLFLpd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 06:45:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234240AbiLFLpb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 06:45:31 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB538175B6
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 03:45:30 -0800 (PST)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B6BBLLh006840;
        Tue, 6 Dec 2022 11:45:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=PDOSWsyne9PBhx3DbPXVP7sntS/00c6kJXsegMpPXQI=;
 b=VHJDQ6+8MFAbxHx/P5ziTK4WKBjyznpFjskNYJTyYj/N8CyuNbOCL5GrXkWw/AOysqlW
 5CnXbNwn4dNEi39LnnB1KLuZe4vc7paB8uA5hicWhAceb9f5almY2ZHkQVTnkxT5qH4x
 k086gRGINzguaRsvjoyYQ+HawheEajyf660OQUv/ikq4EZcrXNoTp4FWIQbpB/Lm71yu
 lq04wE3VR70q3rOZLvGAPZpmFd7+od4D9GZ+rJCbakJIeV0vH47YYhmhgqvh9Lep+RE+
 /nTdZpCTflBY4P49tq9GJFaqbPj9nxvd5vMa1tqkNQPkwYDeaoy/goJQCZ3xrmsO1kBL OQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ma2h1v85n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Dec 2022 11:45:28 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B6BBHje025921;
        Tue, 6 Dec 2022 11:45:27 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ma2h1v84q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Dec 2022 11:45:27 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2B5K58Hu008049;
        Tue, 6 Dec 2022 11:45:25 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3m9ktqgy4c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Dec 2022 11:45:25 +0000
Received: from d06av22.portsmouth.uk.ibm.com ([9.149.105.58])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2B6BjMOb38797586
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Dec 2022 11:45:22 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A9F334C044;
        Tue,  6 Dec 2022 11:45:22 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6F5424C040;
        Tue,  6 Dec 2022 11:45:22 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.56])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  6 Dec 2022 11:45:22 +0000 (GMT)
Date:   Tue, 6 Dec 2022 12:45:21 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH] gitlab-ci: Update to Fedora 37
Message-ID: <20221206124521.76724578@p-imbrenda>
In-Reply-To: <20221206104003.149630-1-thuth@redhat.com>
References: <20221206104003.149630-1-thuth@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: SLZbl8k_XJ243jLwle0Aip1-s1iBGwBB
X-Proofpoint-ORIG-GUID: PvRdFOGiOD7TD9byujsMIb6mVYSTBG9c
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-06_07,2022-12-06_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 adultscore=0 impostorscore=0 suspectscore=0 clxscore=1015
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 spamscore=0
 malwarescore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2210170000 definitions=main-2212060097
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  6 Dec 2022 11:40:03 +0100
Thomas Huth <thuth@redhat.com> wrote:

> Our gitlab-ci jobs were still running with Fedora 32 that is out of
> service already. Let's update to Fedora 37 that brings a new QEMU
> which also allows to run more tests with TCG. While we're at it,
> also list each test in single lines and sort them alphabetically
> so that it is easier to follow which tests get added and removed.
> Beside adding some new tests, two entries are also removed here:
> The "port80" test was removed a while ago from the x86 folder
> already, but not from the .gitlab-ci.yml yet (seems like the run
> script simply ignores unknown tests instead of complaining), and
> the "tsc_adjust" is only skipping in the CI, so it's currently not
> really usefull to try to run it in the CI.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>

Acked-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  .gitlab-ci.yml | 157 +++++++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 132 insertions(+), 25 deletions(-)
> 
> diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
> index e5768f1d..ad7949c9 100644
> --- a/.gitlab-ci.yml
> +++ b/.gitlab-ci.yml
> @@ -1,4 +1,4 @@
> -image: fedora:32
> +image: fedora:37
>  
>  before_script:
>   - dnf update -y
> @@ -10,10 +10,28 @@ build-aarch64:
>   - ./configure --arch=aarch64 --cross-prefix=aarch64-linux-gnu-
>   - make -j2
>   - ACCEL=tcg MAX_SMP=8 ./run_tests.sh
> -     selftest-setup selftest-vectors-kernel selftest-vectors-user selftest-smp
> -     pci-test pmu-cycle-counter pmu-event-counter-config pmu-sw-incr gicv2-ipi
> -     gicv2-mmio gicv3-ipi gicv2-active gicv3-active psci timer cache
> -     | tee results.txt
> +      cache
> +      debug-bp
> +      debug-sstep
> +      debug-wp
> +      gicv2-active
> +      gicv2-ipi
> +      gicv2-mmio
> +      gicv3-active
> +      gicv3-ipi
> +      its-introspection
> +      its-trigger
> +      pci-test
> +      pmu-cycle-counter
> +      pmu-event-counter-config
> +      pmu-sw-incr
> +      psci
> +      selftest-setup
> +      selftest-smp
> +      selftest-vectors-kernel
> +      selftest-vectors-user
> +      timer
> +      | tee results.txt
>   - if grep -q FAIL results.txt ; then exit 1 ; fi
>  
>  build-arm:
> @@ -62,9 +80,32 @@ build-s390x:
>   - ../configure --arch=s390x --cross-prefix=s390x-linux-gnu-
>   - make -j2
>   - ACCEL=tcg ./run_tests.sh
> -     selftest-setup intercept emulator sieve diag10 diag308 vector diag288
> -     stsi sclp-1g sclp-3g
> -     | tee results.txt
> +      adtl-status-no-vec-no-gs-tcg
> +      adtl-status-tcg
> +      cpumodel
> +      css
> +      diag10
> +      diag288
> +      diag308
> +      edat
> +      emulator
> +      epsw
> +      exittime
> +      firq-linear-cpu-ids-tcg
> +      firq-nonlinear-cpu-ids-tcg
> +      iep
> +      intercept
> +      mvpg
> +      sck
> +      sclp-1g
> +      sclp-3g
> +      selftest-setup
> +      sieve
> +      smp
> +      stsi
> +      tprot
> +      vector
> +      | tee results.txt
>   - if grep -q FAIL results.txt ; then exit 1 ; fi
>  
>  build-x86_64:
> @@ -73,12 +114,36 @@ build-x86_64:
>   - ./configure --arch=x86_64
>   - make -j2
>   - ACCEL=tcg ./run_tests.sh
> -     ioapic-split smptest smptest3 vmexit_cpuid vmexit_mov_from_cr8
> -     vmexit_mov_to_cr8 vmexit_inl_pmtimer  vmexit_ipi vmexit_ipi_halt
> -     vmexit_ple_round_robin vmexit_tscdeadline vmexit_tscdeadline_immed
> -     eventinj port80 setjmp sieve syscall tsc rmap_chain umip intel_iommu
> -     rdpru pku pks smap tsc_adjust xsave
> -     | tee results.txt
> +      eventinj
> +      intel_iommu
> +      ioapic-split
> +      memory
> +      pks
> +      pku
> +      rdpru
> +      realmode
> +      rmap_chain
> +      setjmp
> +      sieve
> +      smap
> +      smptest
> +      smptest3
> +      syscall
> +      tsc
> +      umip
> +      vmexit_cpuid
> +      vmexit_cr0_wp
> +      vmexit_cr4_pge
> +      vmexit_inl_pmtimer
> +      vmexit_ipi
> +      vmexit_ipi_halt
> +      vmexit_mov_from_cr8
> +      vmexit_mov_to_cr8
> +      vmexit_ple_round_robin
> +      vmexit_tscdeadline
> +      vmexit_tscdeadline_immed
> +      xsave
> +      | tee results.txt
>   - if grep -q FAIL results.txt ; then exit 1 ; fi
>  
>  build-i386:
> @@ -89,11 +154,29 @@ build-i386:
>   - ../configure --arch=i386
>   - make -j2
>   - ACCEL=tcg ./run_tests.sh
> -     cmpxchg8b vmexit_cpuid vmexit_mov_from_cr8 vmexit_mov_to_cr8
> -     vmexit_inl_pmtimer vmexit_ipi vmexit_ipi_halt vmexit_ple_round_robin
> -     vmexit_tscdeadline vmexit_tscdeadline_immed eventinj port80 setjmp sieve
> -     tsc taskswitch umip rdpru smap tsc_adjust xsave
> -     | tee results.txt
> +      cmpxchg8b
> +      eventinj
> +      realmode
> +      setjmp
> +      sieve
> +      smap
> +      smptest
> +      smptest3
> +      taskswitch
> +      tsc
> +      umip
> +      vmexit_cpuid
> +      vmexit_cr0_wp
> +      vmexit_cr4_pge
> +      vmexit_inl_pmtimer
> +      vmexit_ipi
> +      vmexit_ipi_halt
> +      vmexit_mov_from_cr8
> +      vmexit_mov_to_cr8
> +      vmexit_ple_round_robin
> +      vmexit_tscdeadline
> +      vmexit_tscdeadline_immed
> +      | tee results.txt
>   - if grep -q FAIL results.txt ; then exit 1 ; fi
>  
>  build-clang:
> @@ -102,12 +185,36 @@ build-clang:
>   - ./configure --arch=x86_64 --cc=clang
>   - make -j2
>   - ACCEL=tcg ./run_tests.sh
> -     ioapic-split smptest smptest3 vmexit_cpuid vmexit_mov_from_cr8
> -     vmexit_mov_to_cr8 vmexit_inl_pmtimer  vmexit_ipi vmexit_ipi_halt
> -     vmexit_ple_round_robin vmexit_tscdeadline vmexit_tscdeadline_immed
> -     eventinj port80 setjmp syscall tsc rmap_chain umip intel_iommu
> -     rdpru pku pks smap tsc_adjust xsave
> -     | tee results.txt
> +      eventinj
> +      intel_iommu
> +      ioapic-split
> +      memory
> +      pks
> +      pku
> +      rdpru
> +      realmode
> +      rmap_chain
> +      setjmp
> +      sieve
> +      smap
> +      smptest
> +      smptest3
> +      syscall
> +      tsc
> +      umip
> +      vmexit_cpuid
> +      vmexit_cr0_wp
> +      vmexit_cr4_pge
> +      vmexit_inl_pmtimer
> +      vmexit_ipi
> +      vmexit_ipi_halt
> +      vmexit_mov_from_cr8
> +      vmexit_mov_to_cr8
> +      vmexit_ple_round_robin
> +      vmexit_tscdeadline
> +      vmexit_tscdeadline_immed
> +      xsave
> +      | tee results.txt
>   - grep -q PASS results.txt && ! grep -q FAIL results.txt
>  
>  build-centos7:

