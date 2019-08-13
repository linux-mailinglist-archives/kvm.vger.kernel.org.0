Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF2E08B435
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 11:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727303AbfHMJeI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Aug 2019 05:34:08 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35972 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727107AbfHMJeH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Aug 2019 05:34:07 -0400
Received: by mail-wm1-f67.google.com with SMTP id g67so852800wme.1
        for <kvm@vger.kernel.org>; Tue, 13 Aug 2019 02:34:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=udqo7kROlqFqisXj5oz1sWF1oRTaX6uM+TM5JcYIbqE=;
        b=ABXDmwPSZDHlIb/9qGGIyGJIGgnDh4yqiOzkNgAYlRXx7P9lxkAIJL+GJ2JtkV7H10
         +umXQMtdByBl6D83eMq4G6qNbLglhJpCAdHMsUEvrRywmuYVeSflLHDCzySRJJ+Xj0EG
         5O1OjkO5KIOAO8T0BuP7RnbV8Mj68XRHqOpkdlMEK6YiC4fYgBisqFCucySU9yzl8mRr
         76w5JDFKcQM2vxXqBzNHPsanFmrHu3jUQt9678RRijn1KSgg1eohsESl0w4dn0DRNTcG
         cROH1dGcqgoKdTYCaG763grwzB1XinxGajhV8nPHvGqwSOuGDPgAuBuo8ZeyauGj0d2Q
         CWDg==
X-Gm-Message-State: APjAAAW62C7Mku9/WkdRmIc6MCmwDWnsqIP/EOIUmMUpf75ZPQlBSxze
        g0sO2Wvsoe4Ce+njyHU9GfG9gA==
X-Google-Smtp-Source: APXvYqxoXSubblXg/ubxv7gJT3sw06cSBwphouvlACdbw0oLuVuxziG5Y6exA/d83ei6Qsn3CzcqSw==
X-Received: by 2002:a1c:4d05:: with SMTP id o5mr1991136wmh.129.1565688845929;
        Tue, 13 Aug 2019 02:34:05 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id r23sm996180wmc.38.2019.08.13.02.34.04
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Aug 2019 02:34:05 -0700 (PDT)
Subject: Re: [RFC PATCH v6 00/92] VM introspection
To:     =?UTF-8?Q?Adalbert_Laz=c4=83r?= <alazar@bitdefender.com>,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, virtualization@lists.linux-foundation.org,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        =?UTF-8?Q?Samuel_Laur=c3=a9n?= <samuel.lauren@iki.fi>,
        Patrick Colp <patrick.colp@oracle.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Weijiang Yang <weijiang.yang@intel.com>,
        Yu C Zhang <yu.c.zhang@intel.com>,
        =?UTF-8?Q?Mihai_Don=c8=9bu?= <mdontu@bitdefender.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <a048da21-0b30-8615-a6e5-f3e8f45e7920@redhat.com>
Date:   Tue, 13 Aug 2019 11:34:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190809160047.8319-1-alazar@bitdefender.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/08/19 17:59, Adalbert Lazăr wrote:
> 
> Patches 1-20: unroll a big part of the KVM introspection subsystem,
> sent in one patch in the previous versions.
> 
> Patches 21-24: extend the current page tracking code.
> 
> Patches 25-33: make use of page tracking to support the
> KVMI_SET_PAGE_ACCESS introspection command and the KVMI_EVENT_PF event
> (on EPT violations caused by the tracking settings).
> 
> Patches 34-42: include the SPP feature (Enable Sub-page
> Write Protection Support), already sent to KVM list:
> 
> 	https://lore.kernel.org/lkml/20190717133751.12910-1-weijiang.yang@intel.com/
> 
> Patches 43-46: add the commands needed to use SPP.
> 
> Patches 47-63: unroll almost all the rest of the introspection code.
> 
> Patches 64-67: add single-stepping, mostly as a way to overcome the
> unimplemented instructions, but also as a feature for the introspection
> tool.
> 
> Patches 68-70: cover more cases related to EPT violations.
> 
> Patches 71-73: add the remote mapping feature, allowing the introspection
> tool to map into its address space a page from guest memory.
> 
> Patches 74: add a fix to hypercall emulation.
> 
> Patches 75-76: disable some features/optimizations when the introspection
> code is present.
> 
> Patches 77-78: add trace functions for the introspection code and change
> some related to interrupts/exceptions injection.
> 
> Patches 79-92: new instruction for the x86 emulator, including cmpxchg
> fixes.

Thanks for the very good explanation.  Apart from the complicated flow
of KVM request handling and KVM reply, the main issue is the complete
lack of testcases.  There should be a kvmi_test in
tools/testing/selftests/kvm, and each patch adding a new ioctl or event
should add a new testcase.

Paolo
