Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 596E8F042A
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2019 18:34:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390497AbfKEReF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 5 Nov 2019 12:34:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59266 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390491AbfKEReF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Nov 2019 12:34:05 -0500
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AC53488E4F
        for <kvm@vger.kernel.org>; Tue,  5 Nov 2019 17:34:04 +0000 (UTC)
Received: by mail-wm1-f70.google.com with SMTP id t203so38970wmt.7
        for <kvm@vger.kernel.org>; Tue, 05 Nov 2019 09:34:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=BMfbrDDdhycp+V4IUo9GmouVBKVCyDS9gZpIOUXzmdo=;
        b=ii60Yl6LFIKF7MU4D+mdf/8i9ogmaSo9Vn9EdTzbRjO3vMet7E55JHQgZDQufG5guV
         iYHPUOn/Ee59kZWTtSOmH2gmOiVZ08LOuydO3ukNF9hTo+M59Kuapm14ARoF3CvZnmrT
         Mhpf6TXMyHTp1bU2b5SBbEBto6MIkZRFKU7U4I8hSCSA7iyUiZH2Ym2qcnVP9muuHOkD
         YTtBw8ULPKv6N6j4ASW94WDMrhZ5JsJQlBt8/OE/w1HN0I2KvHY46SEOMxN8mP0jiifJ
         yK9J2TeoSs6DHaKRF9mkiL0IUP96FjlXPDBLtgys26oITqLDxqdWpfMOoifE2cDYy1k0
         5NLg==
X-Gm-Message-State: APjAAAWkWTbeXQfXuPRohEetZMLAYZ0zWDX7G2OrkwIOxhOjH3xZHsCa
        o3km+Zuj5n8Q/nsM78NgUEufQ1ijYRKIlJY6LZXJg4mQvwT0QlD53WxrYPej1VnZk6za884JgVq
        +XpAeztKIBStS
X-Received: by 2002:adf:e903:: with SMTP id f3mr30854032wrm.121.1572975243318;
        Tue, 05 Nov 2019 09:34:03 -0800 (PST)
X-Google-Smtp-Source: APXvYqwEckeFf7/gf8keUjBTJdxGv/uyLrloT6JORCYL32uo1D7t8nPmuWyHlbXT+13GL9phAIUBlg==
X-Received: by 2002:adf:e903:: with SMTP id f3mr30854013wrm.121.1572975243085;
        Tue, 05 Nov 2019 09:34:03 -0800 (PST)
Received: from ?IPv6:2a01:598:b909:23a5:e032:f549:e9f6:ecae? ([2a01:598:b909:23a5:e032:f549:e9f6:ecae])
        by smtp.gmail.com with ESMTPSA id t13sm14699974wrr.88.2019.11.05.09.34.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Nov 2019 09:34:02 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
From:   David Hildenbrand <david@redhat.com>
Mime-Version: 1.0 (1.0)
Subject: Re: [kvm-unit-tests PATCH 0/2] s390x: Improve architectural compliance for diag308
Date:   Tue, 5 Nov 2019 18:34:01 +0100
Message-Id: <70BDB5DE-489D-4718-B6C2-0EABD89414D2@redhat.com>
References: <20191105162828.2490-1-frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com
In-Reply-To: <20191105162828.2490-1-frankja@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
X-Mailer: iPhone Mail (17A878)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> Am 05.11.2019 um 17:29 schrieb Janosch Frank <frankja@linux.ibm.com>:
> 
> ﻿When testing diag308 subcodes 0/1 on lpar with virtual mem set up, I
> experienced spec PGMs and addressing PGMs due to the tests not setting
> short psw bit 12 and leaving the DAT bit on.
> 
> The problem was not found under KVM/QEMU, because Qemu just ignores
> all cpu mask bits... I'm working on a fix for that too.
> 

I don‘t have access to documentation. Is what LPAR does documented behavior or is this completely undocumented and therefore undefined behavior? Then we should remove these test cases completely instead.

> Janosch Frank (2):
>  s390x: Add CR save area
>  s390x: Remove DAT and add short indication psw bits on diag308 reset
> 
> lib/s390x/asm-offsets.c  |  3 ++-
> lib/s390x/asm/arch_def.h |  5 +++--
> lib/s390x/interrupt.c    |  4 ++--
> lib/s390x/smp.c          |  2 +-
> s390x/cstart64.S         | 29 ++++++++++++++++++++---------
> 5 files changed, 28 insertions(+), 15 deletions(-)
> 
> -- 
> 2.20.1
> 
