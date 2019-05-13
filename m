Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4735B1BA60
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 17:49:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729354AbfEMPtV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 11:49:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:35878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727590AbfEMPtV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 11:49:21 -0400
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A26F2166E
        for <kvm@vger.kernel.org>; Mon, 13 May 2019 15:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557762560;
        bh=iu0DvAJjkMh0MqQjI1Y4OdDJERot1b1WNhATGWADuGY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=rp9du5MO21nSayjZvEV1P+McQzueie510+aXWIwZDusr/NFBMwc8rezLPKhgqr32X
         3bpPFK2yS1j9w8/gk2ZvrdLIpltbrgs5fP6MQ8XfN0XLNE6B/el429ftLpgsiSQPsv
         LdGX/qAGGgoG1klNvY2ITJvDZvWta9cbZAHn6heo=
Received: by mail-wm1-f51.google.com with SMTP id n25so14153730wmk.4
        for <kvm@vger.kernel.org>; Mon, 13 May 2019 08:49:19 -0700 (PDT)
X-Gm-Message-State: APjAAAWPVMY4PPgs8ZaESuQ0ID54IHAjfAXI1kXMJcaMDEnhVnuc7We+
        wyl5GCXEpsOIkyDq4nMl2AAF7xBExMTl+tvlx0h+bg==
X-Google-Smtp-Source: APXvYqyggSeuJFq1Eke91tNtR4SA4B4i+YkaoSBUhYCtCAsL8+cTTl0ofap3IWQH83A63l00cYsKpyKbuDbIwRau26E=
X-Received: by 2002:a1c:486:: with SMTP id 128mr15280833wme.83.1557762558612;
 Mon, 13 May 2019 08:49:18 -0700 (PDT)
MIME-Version: 1.0
References: <1557758315-12667-1-git-send-email-alexandre.chartre@oracle.com> <1557758315-12667-6-git-send-email-alexandre.chartre@oracle.com>
In-Reply-To: <1557758315-12667-6-git-send-email-alexandre.chartre@oracle.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Mon, 13 May 2019 08:49:07 -0700
X-Gmail-Original-Message-ID: <CALCETrXmHHjfa3tX2fxec_o165NB0qFBAG3q5i4BaKV==t7F2Q@mail.gmail.com>
Message-ID: <CALCETrXmHHjfa3tX2fxec_o165NB0qFBAG3q5i4BaKV==t7F2Q@mail.gmail.com>
Subject: Re: [RFC KVM 05/27] KVM: x86: Add handler to exit kvm isolation
To:     Alexandre Chartre <alexandre.chartre@oracle.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andrew Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        kvm list <kvm@vger.kernel.org>, X86 ML <x86@kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        jan.setjeeilers@oracle.com, Liran Alon <liran.alon@oracle.com>,
        Jonathan Adams <jwadams@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 13, 2019 at 7:39 AM Alexandre Chartre
<alexandre.chartre@oracle.com> wrote:
>
> From: Liran Alon <liran.alon@oracle.com>
>
> Interrupt handlers will need this handler to switch from
> the KVM address space back to the kernel address space
> on their prelog.

This patch doesn't appear to do anything at all.  What am I missing?
