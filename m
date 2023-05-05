Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B90B56F87DE
	for <lists+kvm@lfdr.de>; Fri,  5 May 2023 19:45:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233087AbjEERpJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 May 2023 13:45:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232116AbjEERpB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 May 2023 13:45:01 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 363371A609
        for <kvm@vger.kernel.org>; Fri,  5 May 2023 10:44:29 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-55a3146ed47so20659717b3.2
        for <kvm@vger.kernel.org>; Fri, 05 May 2023 10:44:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683308665; x=1685900665;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4UGR9YivmYEcSTRGpdP598LIZKffjbaOM0VBNmz81Ko=;
        b=aIZpVqO0ewBIkyLcxcx5BLIbPw1jFtlTBDW51+CzPJAEHQGZqrRDVUnpZ64BVSGUoD
         zuDlW4XggqRQjgTblxnu6KTH2SSYvBtCWa5mrPG3QoRlWIAMYb6yWDoVpW8vaGupXEL7
         ihV6KFddie5FrizIUqrhrfwAqZ2QzYHsk6NBo751FGcjmFazM7EZDNxFXjhyOsUEUNrf
         rxgcc0L7LohRISFRN5EwFrqqcdQ898Y+jVjSPBjUAfB3arDywKB184IwYG99XQfVq0cC
         Urjk1UauMuKISDmTIMRU5PqPiS95sGZrtkbUoNxIWRpcxGd2TCBkRe8j3vPuWZiZsKf4
         t8hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683308665; x=1685900665;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4UGR9YivmYEcSTRGpdP598LIZKffjbaOM0VBNmz81Ko=;
        b=JJE8E9PZ2Iy3FX3LvwMAFrNngC/EcbouuChE95uxUoM/WWSQ3KT1RTJ/o7u80jJP6a
         YmD26KQj0JZjCySWROyS7klK4BQV3uaDsSfb2WmVVg81pHoLSH2ou4f0m8BS6xYhlsWj
         bq4VCLrfmvECrCtijbup+IuBKYC7eT38eV0tXbPPLRDw1DBPR/dZAgT6x70j00XKTd+K
         BWpgZJhj4KvtppmAswTzza3swAK9fSqYDE41WZZiNTFdTxI2LbWALrs5H1fjVcjpUOZZ
         gXNWQyvjuQecjHqL87YQUPnPFmiTSC3MuZpsFGq2ZlzdNiY2NYCuMrCOw14RuEAmGUSi
         XIeA==
X-Gm-Message-State: AC+VfDy0OXvFSjLMWVNDgbyW2DuIdN9CgIsV+awqt3fxzW17eQgh+Y39
        iYwQWvbQ5qBxFg8uXlany997n/qSuqc=
X-Google-Smtp-Source: ACHHUZ48XE0kmEm76zmGYcMENKgA4DKDucvb8LuoBCCKwcStERzugMrETnMV8IJIbQFilScIINZ8iw+iHRE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:4318:0:b0:55a:c44:6151 with SMTP id
 q24-20020a814318000000b0055a0c446151mr1363208ywa.5.1683308665369; Fri, 05 May
 2023 10:44:25 -0700 (PDT)
Date:   Fri, 5 May 2023 10:44:23 -0700
In-Reply-To: <CANZk6aTqiOtJiriSUtZ3myod5hcbV8fb7NA8O2YmUo5PrFyTYw@mail.gmail.com>
Mime-Version: 1.0
References: <1679555884-32544-1-git-send-email-lirongqing@baidu.com>
 <b8facaa4-7dc3-7f2c-e25b-16503c4bfae7@gmail.com> <CANZk6aTqiOtJiriSUtZ3myod5hcbV8fb7NA8O2YmUo5PrFyTYw@mail.gmail.com>
Message-ID: <ZFVAd+SRpnEkw5tx@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Don't create kvm-nx-lpage-re kthread if not itlb_multihit
From:   Sean Christopherson <seanjc@google.com>
To:     zhuangel570 <zhuangel570@gmail.com>
Cc:     Robert Hoo <robert.hoo.linux@gmail.com>, lirongqing@baidu.com,
        pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, kvm@vger.kernel.org,
        x86@kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 05, 2023, zhuangel570 wrote:
> FYI, this is our test scenario, simulating the FaaS business, every VM as=
sign
> 0.1 core, starting lots VMs run in backgroud (such as 800 VM on a machine
> with 80 cores), then burst create 10 VMs, then got 100ms+ latency in crea=
ting
> "kvm-nx-lpage-recovery".
>=20
> On Tue, May 2, 2023 at 10:20=E2=80=AFAM Robert Hoo <robert.hoo.linux@gmai=
l.com> wrote:
> >
> > On 3/23/2023 3:18 PM, lirongqing@baidu.com wrote:
> > > From: Li RongQing <lirongqing@baidu.com>
> > >
> > > if CPU has not X86_BUG_ITLB_MULTIHIT bug, kvm-nx-lpage-re kthread
> > > is not needed to create
> >
> > (directed by Sean from
> > https://lore.kernel.org/kvm/ZE%2FR1%2FhvbuWmD8mw@google.com/ here.)
> >
> > No, I think it should tie to "nx_huge_pages" value rather than
> > directly/partially tie to boot_cpu_has_bug(X86_BUG_ITLB_MULTIHIT).

Lightly tested.  This is what I'm thinking for a "never" param.  Unless som=
eone
has an alternative idea, I'll post a formal patch after more testing.=20

---
 arch/x86/kvm/mmu/mmu.c | 41 ++++++++++++++++++++++++++++++++++++-----
 1 file changed, 36 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c8961f45e3b1..14713c050196 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -58,6 +58,8 @@
=20
 extern bool itlb_multihit_kvm_mitigation;
=20
+static bool nx_hugepage_mitigation_hard_disabled;
+
 int __read_mostly nx_huge_pages =3D -1;
 static uint __read_mostly nx_huge_pages_recovery_period_ms;
 #ifdef CONFIG_PREEMPT_RT
@@ -67,12 +69,13 @@ static uint __read_mostly nx_huge_pages_recovery_ratio =
=3D 0;
 static uint __read_mostly nx_huge_pages_recovery_ratio =3D 60;
 #endif
=20
+static int get_nx_huge_pages(char *buffer, const struct kernel_param *kp);
 static int set_nx_huge_pages(const char *val, const struct kernel_param *k=
p);
 static int set_nx_huge_pages_recovery_param(const char *val, const struct =
kernel_param *kp);
=20
 static const struct kernel_param_ops nx_huge_pages_ops =3D {
 	.set =3D set_nx_huge_pages,
-	.get =3D param_get_bool,
+	.get =3D get_nx_huge_pages,
 };
=20
 static const struct kernel_param_ops nx_huge_pages_recovery_param_ops =3D =
{
@@ -6844,6 +6847,14 @@ static void mmu_destroy_caches(void)
 	kmem_cache_destroy(mmu_page_header_cache);
 }
=20
+static int get_nx_huge_pages(char *buffer, const struct kernel_param *kp)
+{
+	if (nx_hugepage_mitigation_hard_disabled)
+		return sprintf(buffer, "never\n");
+
+	return param_get_bool(buffer, kp);
+}
+
 static bool get_nx_auto_mode(void)
 {
 	/* Return true when CPU has the bug, and mitigations are ON */
@@ -6860,15 +6871,29 @@ static int set_nx_huge_pages(const char *val, const=
 struct kernel_param *kp)
 	bool old_val =3D nx_huge_pages;
 	bool new_val;
=20
+	if (nx_hugepage_mitigation_hard_disabled)
+		return -EPERM;
+
 	/* In "auto" mode deploy workaround only if CPU has the bug. */
-	if (sysfs_streq(val, "off"))
+	if (sysfs_streq(val, "off")) {
 		new_val =3D 0;
-	else if (sysfs_streq(val, "force"))
+	} else if (sysfs_streq(val, "force")) {
 		new_val =3D 1;
-	else if (sysfs_streq(val, "auto"))
+	} else if (sysfs_streq(val, "auto")) {
 		new_val =3D get_nx_auto_mode();
-	else if (kstrtobool(val, &new_val) < 0)
+	} if (sysfs_streq(val, "never")) {
+		new_val =3D 0;
+
+		mutex_lock(&kvm_lock);
+		if (!list_empty(&vm_list)) {
+			mutex_unlock(&kvm_lock);
+			return -EBUSY;
+		}
+		nx_hugepage_mitigation_hard_disabled =3D true;
+		mutex_unlock(&kvm_lock);
+	} else if (kstrtobool(val, &new_val) < 0) {
 		return -EINVAL;
+	}
=20
 	__set_nx_huge_pages(new_val);
=20
@@ -7006,6 +7031,9 @@ static int set_nx_huge_pages_recovery_param(const cha=
r *val, const struct kernel
 	uint old_period, new_period;
 	int err;
=20
+	if (nx_hugepage_mitigation_hard_disabled)
+		return -EPERM;
+
 	was_recovery_enabled =3D calc_nx_huge_pages_recovery_period(&old_period);
=20
 	err =3D param_set_uint(val, kp);
@@ -7161,6 +7189,9 @@ int kvm_mmu_post_init_vm(struct kvm *kvm)
 {
 	int err;
=20
+	if (nx_hugepage_mitigation_hard_disabled)
+		return 0;
+
 	err =3D kvm_vm_create_worker_thread(kvm, kvm_nx_huge_page_recovery_worker=
, 0,
 					  "kvm-nx-lpage-recovery",
 					  &kvm->arch.nx_huge_page_recovery_thread);

base-commit: b3c98052d46948a8d65d2778c7f306ff38366aac
--=20

