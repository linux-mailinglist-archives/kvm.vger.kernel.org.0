Return-Path: <kvm+bounces-2462-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 700437F935D
	for <lists+kvm@lfdr.de>; Sun, 26 Nov 2023 16:24:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0A11BB20F0B
	for <lists+kvm@lfdr.de>; Sun, 26 Nov 2023 15:24:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7881DD313;
	Sun, 26 Nov 2023 15:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5471EB
	for <kvm@vger.kernel.org>; Sun, 26 Nov 2023 07:24:13 -0800 (PST)
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-5be39ccc2e9so4997562a12.3
        for <kvm@vger.kernel.org>; Sun, 26 Nov 2023 07:24:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701012253; x=1701617053;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HNpK7gVVocd6D97UNc/uU33LSZEMZP8thvqp4QD621w=;
        b=R5yJU5DnQKQICCWppjsYBiLNoxNyp1+hgB1AckpzkOSYndUabqRkwSmo9xb+a/Ox8s
         2lm3Hjs4Y85c3Z/ONQM/mJ1SL1OXB2Awum6N8meb3KSJZ3rsk5w76MT7fbcTT0EEwYCH
         iXp+gRdAfEH7rUSrGyvhdps2Yj333LYivK7kwBomjEyhr1Wmx8r18aaAVGpXmLCxtiVB
         cxBC87PBsd4OuiB6jVX5X1WiaK8rZeq9aj3n2gWQ0zJGSbbbuPrNVFA1RewPdxrLiL4U
         MQMbA92MvkgQDF19Sy/tx+Ddg1ojw9qtex9NRAuKOOG9RJzxvuUbC3KeAfnoPD0x8KYQ
         ZxIg==
X-Gm-Message-State: AOJu0YxJq17uf1j9oYPz18qLQWn9O+njCD7Sz7OkYSQuxiE0DajzZt1F
	+Ud9DGmWGv/7NX7Q1xS9JsJg5zUR1CAo1j6RNMkKpqFqbNd/
X-Google-Smtp-Source: AGHT+IHAOAsVy5wek93F9Km67otZrKPfh/qWnTHeq/2VAW8gUxQGL4A7oqrdchvA1bvg38ODschC8brnjEtE8xUekYn4XzvjSKbl
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a63:e310:0:b0:5b9:63f2:e4cc with SMTP id
 f16-20020a63e310000000b005b963f2e4ccmr1497584pgh.2.1701012253177; Sun, 26 Nov
 2023 07:24:13 -0800 (PST)
Date: Sun, 26 Nov 2023 07:24:13 -0800
In-Reply-To: <000000000000ad704b05f8de7e19@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001bfd01060b0fc7dc@google.com>
Subject: Re: [v5.15] WARNING in kvm_arch_vcpu_ioctl_run
From: syzbot <syzbot+412c9ae97b4338c5187e@syzkaller.appspotmail.com>
To: bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
	jarkko@kernel.org, jmattson@google.com, joro@8bytes.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org, mingo@redhat.com, 
	pbonzini@redhat.com, seanjc@google.com, syzkaller-lts-bugs@googlegroups.com, 
	tglx@linutronix.de, usama.anjum@collabora.com, vkuznets@redhat.com, 
	wanpengli@tencent.com, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"

This bug is marked as fixed by commit:
KVM: x86: Remove WARN sanity check on hypervisor timer vs. UNINITIALIZED vCPU

But I can't find it in the tested trees[1] for more than 90 days.
Is it a correct commit? Please update it by replying:

#syz fix: exact-commit-title

Until then the bug is still considered open and new crashes with
the same signature are ignored.

Kernel: Linux 5.15
Dashboard link: https://syzkaller.appspot.com/bug?extid=412c9ae97b4338c5187e

---
[1] I expect the commit to be present in:

1. linux-5.15.y branch of
git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git

