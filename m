Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 469E76F01B0
	for <lists+kvm@lfdr.de>; Thu, 27 Apr 2023 09:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243044AbjD0H1Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Apr 2023 03:27:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242987AbjD0H0z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Apr 2023 03:26:55 -0400
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7C5EEE45
        for <kvm@vger.kernel.org>; Thu, 27 Apr 2023 00:26:54 -0700 (PDT)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8CxE_C9I0pk_XcBAA--.2484S3;
        Thu, 27 Apr 2023 15:26:53 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8Axy7K1I0pk9Ec+AA--.18880S11;
        Thu, 27 Apr 2023 15:26:52 +0800 (CST)
From:   Tianrui Zhao <zhaotianrui@loongson.cn>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        gaosong@loongson.cn, "Michael S . Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, maobibo@loongson.cn,
        zhaotianrui@loongson.cn, philmd@linaro.org,
        richard.henderson@linaro.org, peter.maydell@linaro.org
Subject: [PATCH RFC v2 9/9] target/loongarch: Add loongarch kvm into meson build
Date:   Thu, 27 Apr 2023 15:26:45 +0800
Message-Id: <20230427072645.3368102-10-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230427072645.3368102-1-zhaotianrui@loongson.cn>
References: <20230427072645.3368102-1-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8Axy7K1I0pk9Ec+AA--.18880S11
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjvJXoW7uw4kWF4xAr13uw1fKF17KFg_yoW8GrWDp3
        s3u3WUKF48JrWkJ3s8A3s3XrZxtw13Gw12qayxK34SywsxJ3y7XFn3tasxXF42q3W8KF1S
        vrn3C3W5WF4UJwUanT9S1TB71UUUUUJqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
        qI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUIcSsGvfJTRUUU
        b4xFc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wA2ocxC64kIII0Yj41l84x0c7CEw4
        AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF
        7I0E14v26F4j6r4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7
        CjxVAFwI0_Cr1j6rxdM2kKe7AKxVWUXVWUAwAS0I0E0xvYzxvE52x082IY62kv0487Mc80
        4VCY07AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VCjz48v1sIEY2
        0_WwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lc7CjxVAaw2AFwI0_JF0_
        Jw1l42xK82IYc2Ij64vIr41l42xK82IY6x8ErcxFaVAv8VWrMxC20s026xCaFVCjc4AY6r
        1j6r4UMxCIbckI1I0E14v26r1Y6r17MI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xv
        wVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjx
        v20xvE14v26F1j6w1UMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr1lIxAIcVCF04k2
        6cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4UJVWxJr1lIxAIcVC2z280aVCY1x
        0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0zRXo7NUUUUU=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add kvm.c and kvm-stub.c into meson.build to compile
it when kvm is configed. Meanwhile in meson.build,
we set the kvm_targets to loongarch64-softmmu when
the cpu is loongarch.

Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
---
 meson.build                  | 2 ++
 target/loongarch/meson.build | 1 +
 2 files changed, 3 insertions(+)

diff --git a/meson.build b/meson.build
index b1b29299da..db11f9e2e7 100644
--- a/meson.build
+++ b/meson.build
@@ -114,6 +114,8 @@ elif cpu in ['mips', 'mips64']
   kvm_targets = ['mips-softmmu', 'mipsel-softmmu', 'mips64-softmmu', 'mips64el-softmmu']
 elif cpu in ['riscv']
   kvm_targets = ['riscv32-softmmu', 'riscv64-softmmu']
+elif cpu in ['loongarch64']
+  kvm_targets = ['loongarch64-softmmu']
 else
   kvm_targets = []
 endif
diff --git a/target/loongarch/meson.build b/target/loongarch/meson.build
index 9293a8ab78..0c6cec81e4 100644
--- a/target/loongarch/meson.build
+++ b/target/loongarch/meson.build
@@ -26,6 +26,7 @@ loongarch_softmmu_ss.add(files(
 
 common_ss.add(when: 'CONFIG_LOONGARCH_DIS', if_true: [files('disas.c'), gen])
 
+loongarch_ss.add(when: 'CONFIG_KVM', if_true: files('kvm.c'), if_false: files('kvm-stub.c'))
 loongarch_ss.add_all(when: 'CONFIG_TCG', if_true: [loongarch_tcg_ss])
 
 target_arch += {'loongarch': loongarch_ss}
-- 
2.31.1

