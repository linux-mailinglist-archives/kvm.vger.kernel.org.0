Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E87B37B17
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 19:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730160AbfFFRbR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 13:31:17 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40097 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728720AbfFFRbQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 13:31:16 -0400
Received: by mail-wm1-f65.google.com with SMTP id v19so766129wmj.5
        for <kvm@vger.kernel.org>; Thu, 06 Jun 2019 10:31:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VMj5MhL8kNfJfxn0fwFplPYHIC+cAYknr0O9DpUx30I=;
        b=tDNxYqWZLuWMgozkZNcdqmwXQ9+J6fVhakljA6x4iST2Oaq9rZ+WExC6/UweKhgVOc
         e3NR5cgchE3xSGzqO1Wd83xdi/PLKK2oLpHp+qUXtDhzw7SLhzlsYA5PLrJ2zv/cn0Le
         1K4Yt8Nwhq92aMB1CIhbGfJzHSy9g7F0zXcHPqQDm3+ZHcZ6ZwGfJJoIX3x9bOe/tcAY
         o8oDta3P201pjxJ/5b0gg3KF1CXiluxCylBNj1B9WVyUvuXVjcp/v4BupJ8nHPf5Ww01
         rgtXLnd9kti7NcM4m8gMYXJlgOwbtQAcKBaQBaFTrMD5KuFW2iQJxpYvTYEW/A1+rb+N
         W0pQ==
X-Gm-Message-State: APjAAAVbcRqeVQnzDKoS5BoGhBeOy/5mZSfalYB56F4hKPuxl01edRaL
        SCPVB04Hg1KlSLhfWm8dUsU1CjS1/A0=
X-Google-Smtp-Source: APXvYqxAob2SB4oS7sJc8IN9kaeyAuHIoozNTK1Z5u4n8FvF/JSjYCLlo7pWJLIrAMfgbL8B5wLXRQ==
X-Received: by 2002:a1c:51:: with SMTP id 78mr825124wma.9.1559842274700;
        Thu, 06 Jun 2019 10:31:14 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:657f:501:149f:5617? ([2001:b07:6468:f312:657f:501:149f:5617])
        by smtp.gmail.com with ESMTPSA id t6sm3146686wrp.14.2019.06.06.10.31.13
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 10:31:14 -0700 (PDT)
Subject: Re: [PATCH 2/2] Revert "KVM: nVMX: always use early vmcs check when
 EPT is disabled"
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org
References: <20190520201029.7126-1-sean.j.christopherson@intel.com>
 <20190520201029.7126-3-sean.j.christopherson@intel.com>
 <40c7c3ee-9c49-1df6-c80b-1bc7811ccf69@redhat.com>
 <20190606170837.GC23169@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <eea2b956-2c58-ad2d-7b47-45858c887c03@redhat.com>
Date:   Thu, 6 Jun 2019 19:31:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190606170837.GC23169@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/06/19 19:08, Sean Christopherson wrote:
>> This hunk needs to be moved to patch 1, which then becomes much easier
>> to understand...
> I kept the revert in a separate patch so that the bug fix could be
> easily backported to stable branches (commit 2b27924bb1d4 ("KVM: nVMX:
> always use early vmcs check when EPT is disabled" wasn't tagged for
> stable).
> 

Yeah, I didn't mark it because of the mess involving the vmx.c split
(basically wait and see if someone report it).  There was quite some
churn so I am a bit wary to do stable backports where I haven't
explicitly tested the backport on the oldest affected version.

Paolo
