Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C952823C196
	for <lists+kvm@lfdr.de>; Tue,  4 Aug 2020 23:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728052AbgHDVgm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Aug 2020 17:36:42 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:32833 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727092AbgHDVgm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Aug 2020 17:36:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596577001;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type;
        bh=ouBp08ISRyGkWi4Wd1fL6/w6L0b/51PvvDqvepQsJRg=;
        b=I2RrCZjs/eEHjNWiEB0yDoS66WOjYgTYGLmF66QULtVpzshGzcU4CFFIR3krcfxkWyAESf
        16bOgOG903IPGbE/J6BEoLjcto1H8IoxNupVWyh6dcT8Oe+GDjjARGd8DRG6quV8Byhm1w
        /VDa2vYS8m3rZuNUryJVTlcuPtMY9Dk=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-201-3OECb7prPgyabEiJCHUKJw-1; Tue, 04 Aug 2020 17:36:39 -0400
X-MC-Unique: 3OECb7prPgyabEiJCHUKJw-1
Received: by mail-qk1-f197.google.com with SMTP id c202so23587796qkg.12
        for <kvm@vger.kernel.org>; Tue, 04 Aug 2020 14:36:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition;
        bh=ouBp08ISRyGkWi4Wd1fL6/w6L0b/51PvvDqvepQsJRg=;
        b=FW4iMfPL+f/T225VwlKYvEQ3SnsVEL1h4I+WjqZUQQmjr1WXtRM/RyYlNbBpaDo/pY
         A3IHkymroUUM09hhPj2/HgBwOusURn7dIjZD1g1A+GDwddd3+oqfuy4aBUCuJU/yCXo1
         KzZjmyK1QYuKAIXxTLND7bO/hk05U7CaekDhV06g6u6UMHEfZIIqlocbD/KlDwK1CXJ8
         OLw6cDHlWDMWxhdbanYOiu1blliJiqH6w1cvOopr7n/dned3FzBaQ4rHd2G06VOBCw0b
         YY/S3JkvNpMlW+BGjgKfqiSzRQfdjGADgpL9lLxlc9ZWL/jT0ZsUyE54efmhOf/g4QS4
         IZUQ==
X-Gm-Message-State: AOAM530WFMEjW/1sJwX6lYtZPCPIm0vdaqox7IGjM+W4iNJ8jrhGhNHF
        OUJBJC6H6wFERYg13mlklBVh22NG1iJl9nFdHBVPyrB6WMiPog/fCOhx6ectK+7SmTqxQtIYDRh
        xUEIdLroZoYc8
X-Received: by 2002:ac8:50a:: with SMTP id u10mr93448qtg.175.1596576998866;
        Tue, 04 Aug 2020 14:36:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx34X00b5PTnvDGEEHozrO6KtarBB0W67pPFwmlG8f9/vWqiBjaprFVP+fLZRjedJYZWGN8vw==
X-Received: by 2002:ac8:50a:: with SMTP id u10mr93439qtg.175.1596576998682;
        Tue, 04 Aug 2020 14:36:38 -0700 (PDT)
Received: from redhat.com (bzq-79-177-102-128.red.bezeqint.net. [79.177.102.128])
        by smtp.gmail.com with ESMTPSA id p4sm22769549qkj.135.2020.08.04.14.36.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2020 14:36:37 -0700 (PDT)
Date:   Tue, 4 Aug 2020 17:36:34 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     pbonzini@redhat.com, kvm@vger.kernel.org
Subject: sparse warnings
Message-ID: <20200804173612-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

noticed these hen building with C=1:


arch/x86/kvm/x86.c:2669:38: warning: incorrect type in argument 1 (different address spaces)
arch/x86/kvm/x86.c:2669:38:    expected void const [noderef] __user *
arch/x86/kvm/x86.c:2669:38:    got unsigned char [usertype] *
arch/x86/kvm/x86.c:7636:15: error: incompatible types in comparison expression (different address spaces):
arch/x86/kvm/x86.c:7636:15:    struct kvm_apic_map [noderef] __rcu *
arch/x86/kvm/x86.c:7636:15:    struct kvm_apic_map *
arch/x86/kvm/x86.c:10010:16: error: incompatible types in comparison expression (different address spaces):
arch/x86/kvm/x86.c:10010:16:    struct kvm_apic_map [noderef] __rcu *
arch/x86/kvm/x86.c:10010:16:    struct kvm_apic_map *
arch/x86/kvm/x86.c:10011:15: error: incompatible types in comparison expression (different address spaces):
arch/x86/kvm/x86.c:10011:15:    struct kvm_pmu_event_filter [noderef] __rcu *
arch/x86/kvm/x86.c:10011:15:    struct kvm_pmu_event_filter *
arch/x86/kvm/x86.c: note: in included file (through include/linux/notifier.h, arch/x86/include/asm/uprobes.h, include/linux/uprobes.h, include/linux/mm_types.h, include/asm-generic/fixmap.h, arch/x86/include/asm/fixmap.h, ...):
./include/linux/srcu.h:179:9: warning: context imbalance in 'vcpu_enter_guest' - unexpected unlock


HTH,
-- 
MST

