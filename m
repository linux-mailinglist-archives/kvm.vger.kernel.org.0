Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB96875BFBD
	for <lists+kvm@lfdr.de>; Fri, 21 Jul 2023 09:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbjGUHak (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 03:30:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbjGUHai (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 03:30:38 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F5C210DB
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 00:30:36 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id 38308e7fff4ca-2b962535808so23774621fa.0
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 00:30:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1689924635; x=1690529435;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sVrhGsRHqpb0SJmQRvO/9lQlxmoayB+lW1zezQyO9Ok=;
        b=QpJl7S/e8badX8jT95+A/KHzGPwYS3CIgkPxSBAdlbXGEl84S3Prc7ajvX3bS3ZMLe
         0bIcNJRnAcJ4lpsTOSf1+U3gXYSsCdzrZL41z41rZk0anVizEuY0AS0RsVF5bAZsWGqG
         QFCWCBD2K8OtORWxx7alTRFoZcKbzdW/Fnkczw7/J+J/x2+je33unLiqN4Wi4T9erBvS
         MFbe9434/epO2KOuq4tOS0qHmBuotT4snym+ndYn7RDNrBy0BwR3d3LLysT8Hzmq2Z6l
         KLkkJU6Umev44R31K1w9dkkh5qgMkpSAOY9FCyrCpdQFqpO52x/T1LhQK22u5Tdb9yhV
         Wmvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689924635; x=1690529435;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sVrhGsRHqpb0SJmQRvO/9lQlxmoayB+lW1zezQyO9Ok=;
        b=Tpb2bg162mtenFdNEs7hJJViC+Ras1r9iVaE9iLfkRbWsOCHZNQ5ZkLLGfMDEEObbo
         F0TA4vmL9DyLx8eDQb+b7d1jSDCUR+nfu9VNBfqxXyyWiWgEURB7tCbwOCZ+j3EKYaGT
         bWLUf91uy1gzxs1GuBgTgFrJ+fvwKpsz61Vhbo1B6i6Fm3FYigZgElxhfe04j5Y9UVwp
         MeKb/y1R0uU1AtLPPvNKme/Ep4wj6exEtZA7ofEToVKhXZXA5K+zNi+cAq3SycMCAWWJ
         WMvcdgrprJnCXf+Nr+pA4drhBBHbBnCjJHwYQJWzKAsw/4puJ2wEPCdWTMO6Ywef6Zmv
         ASDg==
X-Gm-Message-State: ABy/qLbyoxpD8imSt+ikejyuTCyrbmgwkpqu3sda2ZfcYN+XCE892RtF
        0fBjmnHUl2yqcimgJOxMXp/50g==
X-Google-Smtp-Source: APBJJlEYSTv1ML1XNlOikJMyQbfxJOl8iaoeYeBrEcPuOlBAPeNMlQX6IjhnEjmBWX3/1V2Fuw2I/w==
X-Received: by 2002:a2e:b0f0:0:b0:2b9:5b06:b724 with SMTP id h16-20020a2eb0f0000000b002b95b06b724mr1011423ljl.42.1689924634806;
        Fri, 21 Jul 2023 00:30:34 -0700 (PDT)
Received: from [192.168.96.175] (97.red-88-29-184.dynamicip.rima-tde.net. [88.29.184.97])
        by smtp.gmail.com with ESMTPSA id y13-20020a05600c364d00b003fbb25da65bsm2795160wmq.30.2023.07.21.00.30.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Jul 2023 00:30:34 -0700 (PDT)
Message-ID: <05d4e5ff-dc5c-b2da-7ae8-ac135d4a73c9@linaro.org>
Date:   Fri, 21 Jul 2023 09:30:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.13.0
Subject: Re: [PATCH v2] accel/kvm: Specify default IPA size for arm64
To:     Akihiko Odaki <akihiko.odaki@daynix.com>
Cc:     qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>
References: <20230721062421.12017-1-akihiko.odaki@daynix.com>
Content-Language: en-US
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20230721062421.12017-1-akihiko.odaki@daynix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Akihiko,

On 21/7/23 08:24, Akihiko Odaki wrote:
> libvirt uses "none" machine type to test KVM availability. Before this
> change, QEMU used to pass 0 as machine type when calling KVM_CREATE_VM.
> 
> The kernel documentation says:
>> On arm64, the physical address size for a VM (IPA Size limit) is
>> limited to 40bits by default. The limit can be configured if the host
>> supports the extension KVM_CAP_ARM_VM_IPA_SIZE. When supported, use
>> KVM_VM_TYPE_ARM_IPA_SIZE(IPA_Bits) to set the size in the machine type
>> identifier, where IPA_Bits is the maximum width of any physical
>> address used by the VM. The IPA_Bits is encoded in bits[7-0] of the
>> machine type identifier.
>>
>> e.g, to configure a guest to use 48bit physical address size::
>>
>>      vm_fd = ioctl(dev_fd, KVM_CREATE_VM, KVM_VM_TYPE_ARM_IPA_SIZE(48));
>>
>> The requested size (IPA_Bits) must be:
>>
>>   ==   =========================================================
>>    0   Implies default size, 40bits (for backward compatibility)
>>    N   Implies N bits, where N is a positive integer such that,
>>        32 <= N <= Host_IPA_Limit
>>   ==   =========================================================
> 
>> Host_IPA_Limit is the maximum possible value for IPA_Bits on the host
>> and is dependent on the CPU capability and the kernel configuration.
>> The limit can be retrieved using KVM_CAP_ARM_VM_IPA_SIZE of the
>> KVM_CHECK_EXTENSION ioctl() at run-time.
>>
>> Creation of the VM will fail if the requested IPA size (whether it is
>> implicit or explicit) is unsupported on the host.
> https://docs.kernel.org/virt/kvm/api.html#kvm-create-vm
> 
> So if Host_IPA_Limit < 40, such KVM_CREATE_VM will fail, and libvirt
> incorrectly thinks KVM is not available. This actually happened on M2
> MacBook Air.
> 
> Fix this by specifying 32 for IPA_Bits as any arm64 system should
> support the value according to the documentation.
> 
> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
> ---
> V1 -> V2: Introduced an arch hook
> 
>   include/sysemu/kvm.h   | 1 +
>   accel/kvm/kvm-all.c    | 2 +-
>   target/arm/kvm.c       | 2 ++
>   target/i386/kvm/kvm.c  | 2 ++
>   target/mips/kvm.c      | 2 ++
>   target/ppc/kvm.c       | 2 ++
>   target/riscv/kvm.c     | 2 ++
>   target/s390x/kvm/kvm.c | 2 ++
>   8 files changed, 14 insertions(+), 1 deletion(-)

My understanding of Peter's suggestion would be smth like:

-- >8 --
diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index 115f0cca79..c0af15eb6c 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -201,10 +201,15 @@ typedef struct KVMCapabilityInfo {

  struct KVMState;

+struct KVMClass {
+    AccelClass parent_class;
+
+    int default_vm_type;
+};
+
  #define TYPE_KVM_ACCEL ACCEL_CLASS_NAME("kvm")
  typedef struct KVMState KVMState;
-DECLARE_INSTANCE_CHECKER(KVMState, KVM_STATE,
-                         TYPE_KVM_ACCEL)
+OBJECT_DECLARE_TYPE(KVMState, KVMClass, KVM_ACCEL)

  extern KVMState *kvm_state;
  typedef struct Notifier Notifier;
diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 373d876c05..fdd424e1a5 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2458,12 +2458,13 @@ static int kvm_init(MachineState *ms)
      KVMState *s;
      const KVMCapabilityInfo *missing_cap;
      int ret;
-    int type = 0;
+    int type;
      uint64_t dirty_log_manual_caps;

      qemu_mutex_init(&kml_slots_lock);

      s = KVM_STATE(ms->accelerator);
+    type = KVM_GET_CLASS(s)->default_vm_type;

      /*
       * On systems where the kernel can support different base page
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index b4c7654f49..5c13594fdf 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -1064,4 +1064,8 @@ bool kvm_arch_cpu_check_are_resettable(void)

  void kvm_arch_accel_class_init(ObjectClass *oc)
  {
+    KVMClass *kc = KVM_CLASS(oc);
+
+    /* Host_IPA_Limit ... */
+    kc->default_vm_type = 32;
  }
---
