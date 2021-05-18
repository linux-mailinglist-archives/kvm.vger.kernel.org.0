Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C37D6387845
	for <lists+kvm@lfdr.de>; Tue, 18 May 2021 14:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348982AbhERMCz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 08:02:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233662AbhERMCu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 May 2021 08:02:50 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65F60C061573;
        Tue, 18 May 2021 05:01:32 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id j6-20020a17090adc86b02900cbfe6f2c96so1419317pjv.1;
        Tue, 18 May 2021 05:01:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=em3y75NXotaLU/AKtI4LMXPcEnf5Ld1kv/mHHILm70c=;
        b=V/p4lH/6d5UguGqICWMegLeErmFH7naXSe4DlY8l+O9zRNBHKkp8LUKd2lN4M2qCZ/
         Trfkad+GRBI0RamLpWK3ZyCmXmEqFbV6NJePLgTFCNJjgMHwGWgCRtKt00TIYG0joO4k
         anoh6qGD6DuPuv5gV77s2MQLWPIO5Kx3XOTx+XtklL587DU3TGpUjnvGY3qK9Ntrg/IG
         /cYtXr8tfUYW2Qkv/HpRerACyiOJdAlfcp0KaWDk0Yvlo+LjdkWl41LDnazF1MNDs5Bw
         HlfGiR1kq7LWa2iaXyCbebVh9T/ue0MEoJ69JYBlgMZ0z8HSU8xW2H/p7ngeQ7Cqy9ni
         eJLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=em3y75NXotaLU/AKtI4LMXPcEnf5Ld1kv/mHHILm70c=;
        b=osG/hjTWDXsgCY9PgdzdlhEM9OlZzIHq+F1PmWpYyzmOZKKuoKD9Q13auMHnCGoK5B
         2yM0hc5Cgo+8QjUGtRE59skDh8Mua0FsTb2pnPuq+ZGiemUIqri6cDoFO9ITdwpcl/qh
         Hw32QwOH0dlztBCl3K/h6wpA8cjnEI7L5NyTWAghXn3yioj7jfoF2Y1KVq/VoHjBNUTv
         AioiQY4z/eJvsiZgFrHAYgCirjEJiKleEXpczWCvShONyqWPM4+wyhNugJDqw1InUX+Y
         gKb0JH55oSusiJTUz9cm0eeqwzAh3OrWX3E5QD20/trBoFxKjrOD6j7FchhE6VVUA6P6
         xr0w==
X-Gm-Message-State: AOAM5329CEqUv76cUaLUwUFubKkIzjj9ZkB5r3xycnMQqU2EEYVvUir9
        SgwLLUiehss3a4CVC+EJbru/M3OX+Q0=
X-Google-Smtp-Source: ABdhPJzuaIu1kDieJYdkyutSSE1hKoGm9LjVD+Vi0D2+YlF331ZxLvgY6I3C4fUQhe3dRm4RAN44MQ==
X-Received: by 2002:a17:902:f203:b029:f0:d225:c6e4 with SMTP id m3-20020a170902f203b02900f0d225c6e4mr4271634plc.0.1621339291776;
        Tue, 18 May 2021 05:01:31 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.53])
        by smtp.googlemail.com with ESMTPSA id l20sm12757394pjq.38.2021.05.18.05.01.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 May 2021 05:01:31 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Ben Segall <bsegall@google.com>,
        Venkatesh Srinivas <venkateshs@chromium.org>,
        David Matlack <dmatlack@google.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Suraj Jitindar Singh <sjitindarsingh@gmail.com>
Subject: [PATCH v4 1/5] KVM: exit halt polling on need_resched() for both book3s and generic halt-polling
Date:   Tue, 18 May 2021 05:00:31 -0700
Message-Id: <1621339235-11131-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Inspired by commit 262de4102c7bb8 (kvm: exit halt polling on need_resched()
as well), CFS_BANDWIDTH throttling will use resched_task() when there is just
one task to get the task to block. It was likely allowing VMs to overrun their
quota when halt polling. Due to PPC implements an arch specific halt polling
logic, we should add the need_resched() checking there as well. This
patch adds a helper function that to be shared between book3s and generic
halt-polling loop.

Reviewed-by: David Matlack <dmatlack@google.com>
Reviewed-by: Venkatesh Srinivas <venkateshs@chromium.org>
Cc: Ben Segall <bsegall@google.com>
Cc: Venkatesh Srinivas <venkateshs@chromium.org>
Cc: Jim Mattson <jmattson@google.com> 
Cc: David Matlack <dmatlack@google.com>
Cc: Paul Mackerras <paulus@ozlabs.org>
Cc: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
v3 -> v4:
 * rename to kvm_vcpu_can_poll
v2 -> v3:
 * add a helper function
v1 -> v2:
 * update patch description

 arch/powerpc/kvm/book3s_hv.c | 2 +-
 include/linux/kvm_host.h     | 2 ++
 virt/kvm/kvm_main.c          | 8 ++++++--
 3 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 28a80d240b76..7360350e66ff 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3936,7 +3936,7 @@ static void kvmppc_vcore_blocked(struct kvmppc_vcore *vc)
 				break;
 			}
 			cur = ktime_get();
-		} while (single_task_running() && ktime_before(cur, stop));
+		} while (kvm_vcpu_can_poll(cur, stop));
 
 		spin_lock(&vc->lock);
 		vc->vcore_state = VCORE_INACTIVE;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 2f34487e21f2..ba682f738a25 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1583,4 +1583,6 @@ static inline void kvm_handle_signal_exit(struct kvm_vcpu *vcpu)
 /* Max number of entries allowed for each kvm dirty ring */
 #define  KVM_DIRTY_RING_MAX_ENTRIES  65536
 
+bool kvm_vcpu_can_poll(ktime_t cur, ktime_t stop);
+
 #endif
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6b4feb92dc79..62522c12beba 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2945,6 +2945,11 @@ update_halt_poll_stats(struct kvm_vcpu *vcpu, u64 poll_ns, bool waited)
 		vcpu->stat.halt_poll_success_ns += poll_ns;
 }
 
+bool kvm_vcpu_can_poll(ktime_t cur, ktime_t stop)
+{
+	return single_task_running() && !need_resched() && ktime_before(cur, stop);
+}
+
 /*
  * The vCPU has executed a HLT instruction with in-kernel mode enabled.
  */
@@ -2973,8 +2978,7 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 				goto out;
 			}
 			poll_end = cur = ktime_get();
-		} while (single_task_running() && !need_resched() &&
-			 ktime_before(cur, stop));
+		} while (kvm_vcpu_can_poll(cur, stop));
 	}
 
 	prepare_to_rcuwait(&vcpu->wait);
-- 
2.25.1

