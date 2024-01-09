Return-Path: <kvm+bounces-5905-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 266BA828C5B
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 19:19:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B95E61F27531
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 18:18:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B67693C099;
	Tue,  9 Jan 2024 18:18:21 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB7E23C063
	for <kvm@vger.kernel.org>; Tue,  9 Jan 2024 18:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-36063568308so27572765ab.0
        for <kvm@vger.kernel.org>; Tue, 09 Jan 2024 10:18:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704824299; x=1705429099;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HNpK7gVVocd6D97UNc/uU33LSZEMZP8thvqp4QD621w=;
        b=g3WBXWMtmynSXZjQmQW90DYHu+eM7KDtZNVf91pScgSNUpWHvxzVQ/I2U9btJOwy44
         9qZN3iJBj6NqS1B1sPoUqtV0ujcWLaLJykFE5w0n6FrwH8v5N5RNT4VdENq2xliGb3C0
         y5V/gD03dIBSl2SIBtbIk+IhvOc62Pq3YSUeXyqVyVhSGbtOVe4JavUGmLirIOzPH5Jo
         DDigH2OIRgAw+19Bd2bzcHhd1IS05PC6rKlYRsusw7NJIuo3VsTuW64fKVWooIFvWh3a
         HgcdQMFwkrp5vg9J7J24CBqrjTC1DMBVRelE8y9E9P1FAae1Z1yKrZiQKvzDrkRW+16K
         SK/A==
X-Gm-Message-State: AOJu0YyXpCjrIho8FJ+NtG5/Pf4Hk/tz8vaWYhK3860VhIb10OoJRDwe
	/2VmbbOrBynPrBFelgVRNiOvz9kQGVzWN65hcT9VBDSvE/lF
X-Google-Smtp-Source: AGHT+IFgdzZhVll0vqDBLPtBr0CdUuR3oPuenR201DKKqtRq5gwIMqq5HsJitrmlvd2DvVekAcF1MZDcpzq97v7Ch3Jr1fu3gxYN
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:b43:b0:35f:ebc7:6065 with SMTP id
 f3-20020a056e020b4300b0035febc76065mr497173ilu.1.1704824299204; Tue, 09 Jan
 2024 10:18:19 -0800 (PST)
Date: Tue, 09 Jan 2024 10:18:19 -0800
In-Reply-To: <000000000000ad704b05f8de7e19@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c237b7060e875640@google.com>
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

