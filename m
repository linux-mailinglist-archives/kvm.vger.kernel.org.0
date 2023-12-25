Return-Path: <kvm+bounces-5202-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7279B81DF36
	for <lists+kvm@lfdr.de>; Mon, 25 Dec 2023 09:42:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E78152819FD
	for <lists+kvm@lfdr.de>; Mon, 25 Dec 2023 08:42:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5272F3D9C;
	Mon, 25 Dec 2023 08:42:16 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF361186B
	for <kvm@vger.kernel.org>; Mon, 25 Dec 2023 08:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-7ba97338185so392254339f.1
        for <kvm@vger.kernel.org>; Mon, 25 Dec 2023 00:42:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703493734; x=1704098534;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HNpK7gVVocd6D97UNc/uU33LSZEMZP8thvqp4QD621w=;
        b=RkU0UUlcs8sBTAt4ZUvWx7k4V3AvU1pSLvqgrK8hHCj/xd6Sow2FovW/CRL3c9ABBU
         R9Oj0npCCkSGLQIsfCF02sIfnactZdJIhY1BhN9TyUPNXkjkCMDFddZicvUDSHmMlv/A
         v+UEj4B0O6VUXKHEhRkSdVMQfA5+TzB9LLMhasTvoKzpAmV5m3CXzZhSeGxFZoUAJ5u/
         ZlXGyiCBYTRJHG29OJIkRSdyfLALgHjTdhLHJ6+x4gjcolcAJpYxYUq3ZSbAcujMfVEM
         6OXW+ogavCzqZLyZFFAhp4jSpRfp5QO8XHi66e8+kpUXr9dYoeJw51x/vL5zK2NDH/J6
         AEug==
X-Gm-Message-State: AOJu0YyqVwu2paOA1ZxQ8kDjuvwu7xRklmn8Dxt9U2vf9UtFiUS94bfL
	OGl8mnIpoOE4rk8HipsnVxyu/6+27iIr1jh2j3rSFK+EiXwU
X-Google-Smtp-Source: AGHT+IG3dYA8NKJcN7EVOtfhsfJebVt6ntLuqWhU4s5iyxWjBECkL6g/8PzJsZReEl/yaZ8GUJMt+8bHRF8dIhO+grGV128vuQw/
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1d87:b0:35f:8652:5ce8 with SMTP id
 h7-20020a056e021d8700b0035f86525ce8mr619071ila.4.1703493733927; Mon, 25 Dec
 2023 00:42:13 -0800 (PST)
Date: Mon, 25 Dec 2023 00:42:13 -0800
In-Reply-To: <000000000000ad704b05f8de7e19@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e355bc060d518a7e@google.com>
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

