Return-Path: <kvm+bounces-4027-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5515A80C375
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 09:41:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 53F561C20979
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 08:41:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2594C210EF;
	Mon, 11 Dec 2023 08:41:17 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com [209.85.210.71])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 293EAF1
	for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 00:41:13 -0800 (PST)
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-6d9d822a6f3so5968591a34.0
        for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 00:41:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702284072; x=1702888872;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HNpK7gVVocd6D97UNc/uU33LSZEMZP8thvqp4QD621w=;
        b=seNxzECPWQ9nbbUs+kU9FHIYlraMdRo/Z6XYL6gAh3vJYW7X1Epr287tJkzC5P52Ci
         mv7aK3Iy4skXlkXpS4jbrKpq3MhS+HO6FKH62wajcb/FCoaZvbnrtZ/m+rxuCc4SDYeE
         iPv3S95fNPBvxJZlnI2Gy0mhw51qNdGn038wbCal8siW/qhqL2jsSAg6edwRHZ4tSzxk
         49qGwtcSBSedEChcAnJTslojuIDNO1yGo7Qp493jeeN6Rt6u1l9wIRyMnlDPyQBirA6/
         2qhFGz8EuA/C0C/+vsj+cbZGTri8vpiZbs4KmcgwQCbWePjhZaiqTy1XwKWCPGvnT9ED
         Tgkg==
X-Gm-Message-State: AOJu0YwKg86TcyS/67C640IB+rHvLjV2hqQ8LctQQcXisOEIcJMpeeLC
	4yhS+hhBLiUpSj0SxNgdEEGZUuuxbhg9EMgIFTyueeHYxeb2
X-Google-Smtp-Source: AGHT+IGfKrROzc73KF0ejaUWsIpnsUmLsLBlTMqcRYfFE/B2YIdyfJZ5i9qn/JPhnNqB+AehJiu4dzQCN/IdUWyYcy93lo6E05KY
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6830:4104:b0:6d9:e33a:e4e7 with SMTP id
 w4-20020a056830410400b006d9e33ae4e7mr4031696ott.1.1702284072435; Mon, 11 Dec
 2023 00:41:12 -0800 (PST)
Date: Mon, 11 Dec 2023 00:41:12 -0800
In-Reply-To: <000000000000ad704b05f8de7e19@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000071c5ec060c37e5e1@google.com>
Subject: Re: [v5.15] WARNING in kvm_arch_vcpu_ioctl_run
From: syzbot <syzbot+412c9ae97b4338c5187e@syzkaller.appspotmail.com>
To: bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
	jarkko@kernel.org, jmattson@google.com, joro@8bytes.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org, mingo@redhat.com, 
	pbonzini@redhat.com, seanjc@google.com, syzkaller-lts-bugs@googlegroups.com, 
	tglx@linutronix.de, usama.anjum@collabora.com, vkuznets@redhat.com, 
	wanpengli@tencent.com, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Level: **

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

