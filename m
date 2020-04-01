Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FC5519A96D
	for <lists+kvm@lfdr.de>; Wed,  1 Apr 2020 12:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732213AbgDAKUP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Apr 2020 06:20:15 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:45916 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732110AbgDAKUP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Apr 2020 06:20:15 -0400
Received: by mail-lj1-f193.google.com with SMTP id t17so25205370ljc.12
        for <kvm@vger.kernel.org>; Wed, 01 Apr 2020 03:20:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ENHstGjuwW2yo3COsGAECyjpxrxaSoZPQXrr2CDIHqY=;
        b=ktrc8MpUEQ5QI60gYoRyEuvXwXfpEqx3M/fJrox89MhNAHgYG86XLaLOivQ4eQVGSK
         G89OY/Z844A8pm6YBWQeSS0CI0luQUhL0yFIhrDRDU5jwFln6jdw3yd593tYuFNvpFFy
         0Fq7m8s9XhFlbYHxrtmek5bt2Xh4APWdRr1dgaqv5KSP94GHOm7PRhJlpzgD6CXET2GK
         Oa3eVgsfIYfPHmP+KqTY9XrTNUYqMf1lNt5eWOT/gT8/2zATPWyIhGwf3GLewEcss9qg
         9AOKRvdVO/l5lA9eo+oCI4YtDu8dguLTOWS8IF6jTn5KrGbNF7S+8G2s8syNS+unUgSr
         24UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ENHstGjuwW2yo3COsGAECyjpxrxaSoZPQXrr2CDIHqY=;
        b=nR2x2Fbi5gbt3ChUMIkp6YXqRPDnlc7C6KLrj+kbUEUKUqDGTUSTY8uS92RqitgeNB
         ucpa25NbuqNENSdYexZ1vMyYphMQPT8M6CnVJ1SP9+h+6eO5BhViyOIBEINKpqbv99BB
         m9YEM7MFx0BHfRSon/qr63tUChQDt3Ami8EJJ7Z71gi5JcnhIr2n4Lw7mJnm+d4ryhJg
         F49W6bgVWZdhQz9M4WGPs2bzSGmAbUZh/oB9YxkH36cxc/TbZVuOaevC76BUG+b7IwWo
         Qi9yrUY7gA048cnXxGM9r0/DVVafECJGDlR4A2CkWH0fEyjnof9JiUsnZU58ymbIBWEv
         J8DQ==
X-Gm-Message-State: AGi0PuYJjc8mOLbMFUOdon5szx+AERKclTtgedapEH291rUmK6AsyQfo
        VXOxQuy7hkr/KmNTnvi9MaRYEA==
X-Google-Smtp-Source: APiQypL9WDxbsq4oYKXr36Yb9n5DZ8OQKZ64pbm4DDxE1ew8kCL3RjSimoOmg9MTrlry5TTqx+bKuQ==
X-Received: by 2002:a2e:9a54:: with SMTP id k20mr12504657ljj.272.1585736411428;
        Wed, 01 Apr 2020 03:20:11 -0700 (PDT)
Received: from ?IPv6:2a00:1fa0:245:3fc8:782f:cdd9:3f89:e462? ([2a00:1fa0:245:3fc8:782f:cdd9:3f89:e462])
        by smtp.gmail.com with ESMTPSA id u30sm1307508lfn.2.2020.04.01.03.20.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Apr 2020 03:20:10 -0700 (PDT)
Subject: Re: [PATCH] KVM: MIPS: fix compilation
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     linux-mips@vger.kernel.org, peterx@redhat.com, rppt@linux.ibm.com
References: <20200331154749.5457-1-pbonzini@redhat.com>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <b2689d50-f5fe-c7ba-eede-f11920f1d012@cogentembedded.com>
Date:   Wed, 1 Apr 2020 13:20:02 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200331154749.5457-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello!

On 31.03.2020 18:47, Paolo Bonzini wrote:

> Commit 31168f033e37 is correct that pud_index() & __pud_offset() are the same

    You should also specify the commit's 1-line summary enclosed in ("").

> when pud_index() is actually provided, however it does not take into account
> the __PAGETABLE_PUD_FOLDED case.  Provide kvm_pud_index so that MIPS KVM
> compiles.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[...]

MBR, Sergei
