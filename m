Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 880CC3E0CDD
	for <lists+kvm@lfdr.de>; Thu,  5 Aug 2021 05:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238550AbhHEDpS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Aug 2021 23:45:18 -0400
Received: from m32-153.88.com ([43.250.32.153]:49024 "EHLO email.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232113AbhHEDpS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Aug 2021 23:45:18 -0400
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Aug 2021 23:45:17 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=email.cn;
        s=dkim; h=From:To:Date; bh=5wdJNGYtufzjIgVuAGpajGtzpDQxsxxZzF255
        aDEswY=; b=LNn3MEQYbu9aF2fNKwxE/Yap1ijll0CTJUWYB/rwqHB82o4cVu/oO
        tWlthf0affmKRx8AB3UAbRhwC64ZtbTa+J1m0rzlq5QJezFoUuCbseGKC8FFoZPT
        TrLK8+nEIdgYL/IH5krclgbhyonWb+WP7wO5aGIdf3cTrRzcJKsnGA=
Received: from localhost.localdomain (unknown [113.251.8.125])
        by v_coremail2-frontend-2 (Coremail) with SMTP id GiKnCgD3dqeOXQtheOMcAA--.40156S2;
        Thu, 05 Aug 2021 11:40:00 +0800 (CST)
From:   Hu Haowen <src.res@email.cn>
To:     pbonzini@redhat.com, corbet@lwn.net
Cc:     kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] docs: virt: kvm: api.rst: lengthen title line
Date:   Thu,  5 Aug 2021 11:39:58 +0800
Message-Id: <20210805033958.120924-1-src.res@email.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: GiKnCgD3dqeOXQtheOMcAA--.40156S2
X-Coremail-Antispam: 1UD129KBjvdXoW7XFWxAr43Zry5Cw1UWr4rZrb_yoW3WFbE9F
        WDtF4Utw18J3yjvr4UGayrXF17Xa1UCF1kCr15GF4UAwnxArsxGF9rJ39Y9FWUWwsrury5
        Xrs8Xr4rJrnrXjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbOxYjsxI4VWDJwAYFVCjjxCrM7CY07I20VC2zVCF04k26cxKx2IY
        s7xG6rWj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI
        8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1l84ACjcxK6I8E
        87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AKxVW8Jr0_Cr1UM2AIxVAIcx
        kEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6x8ErcxFaVAv8VWx
        Jr1UJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lc2xSY4AK67AK6r48Mx
        AIw28IcxkI7VAKI48JMxAIw28IcVCjz48v1sIEY20_Cr1UJr1l4I8I3I0E4IkC6x0Yz7v_
        Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1V
        AY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAI
        cVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42
        IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVj
        vjDU0xZFpf9x07U46wZUUUUU=
X-Originating-IP: [113.251.8.125]
X-CM-SenderInfo: hvufh21hv6vzxdlohubq/
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Lengthen the underline of title "8.28 KVM_CAP_ENFORCE_PV_FEATURE_CPUID"
in order to fix build warnings.

Signed-off-by: Hu Haowen <src.res@email.cn>
---
 Documentation/virt/kvm/api.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index c6212c2d5fe3..2c15844c0d72 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7054,7 +7054,7 @@ trap and emulate MSRs that are outside of the scope of KVM as well as
 limit the attack surface on KVM's MSR emulation code.
 
 8.28 KVM_CAP_ENFORCE_PV_FEATURE_CPUID
------------------------------
+-------------------------------------
 
 Architectures: x86
 
-- 
2.25.1

