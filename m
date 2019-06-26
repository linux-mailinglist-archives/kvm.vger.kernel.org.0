Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAD9756852
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2019 14:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbfFZMKy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jun 2019 08:10:54 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39078 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726242AbfFZMKy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jun 2019 08:10:54 -0400
Received: by mail-wr1-f67.google.com with SMTP id x4so2456642wrt.6
        for <kvm@vger.kernel.org>; Wed, 26 Jun 2019 05:10:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9Fy5r+CcybLkgqizhpcEMO9CkuvE4eogqAqSodMLv4o=;
        b=QJfJlt7WwZ/5g8TgOvkR8WOGhMJJtv1H2Y1Ph8A46KaGKx+YiHOyHFxLqI/A8vx32k
         J/hBu29r7PjK5jEsBsS4kqc5mwgehZkMrFcCMZibGOxmeSNvB7aL2Y2TPMC7iQHzhS1n
         h9BjRFHkrI/+nBv+bB0BK1XW2ckaHvhkZvhGt5cjsVhIGjkNy+lCbQqPFfOZDXaYXLcJ
         cL2ip7GwUXofDbW+0/+5UCPbJojLEh+CbfoMJeq3sGRUBywXyNzbEPilYzpeTzdIrqOp
         I40KVT4L758pfnlOLy3DE890jbzzBgj4BAwYJlvSxVZQzI05cycz90H5A0WcqW4buD7y
         w49g==
X-Gm-Message-State: APjAAAXHCC7c8Idi96PUMl2bHqw6urmvhPj0PgAmksJQSiJD514QGGtA
        Nqq1BvlDIyRlkpyBWUSjByZ9GQ==
X-Google-Smtp-Source: APXvYqywxu4LW+QmiWawPPqTqo8BLDzTZPpf2KNEYpQW4BuKrzXDIchGU7Ft4v4pYOKdBagHiAj/5g==
X-Received: by 2002:adf:dfc5:: with SMTP id q5mr3653535wrn.142.1561551052960;
        Wed, 26 Jun 2019 05:10:52 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e88d:856c:e081:f67d? ([2001:b07:6468:f312:e88d:856c:e081:f67d])
        by smtp.gmail.com with ESMTPSA id o2sm15884318wrq.56.2019.06.26.05.10.52
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Jun 2019 05:10:52 -0700 (PDT)
Subject: Re: [PATCH] x86/kvm/nVMCS: fix VMCLEAR when Enlightened VMCS is in
 use
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Liran Alon <liran.alon@oracle.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
References: <20190624133028.3710-1-vkuznets@redhat.com>
 <CEFF2A14-611A-417C-BC0A-8814862F26C6@oracle.com>
 <87r27jdq68.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9d54ff67-cf30-5e56-954d-6d7a4a8e87f7@redhat.com>
Date:   Wed, 26 Jun 2019 14:10:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <87r27jdq68.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/06/19 16:16, Vitaly Kuznetsov wrote:
>>> 	gpa_t vmptr;
>>> +	u64 evmptr;
>> I prefer to rename evmptr to evmcs_ptr. I think it’s more readable and sufficiently short.
>>
> Sure.
> 

Let's make it evmcs_gpa instead.  "*_ptr" or "p_*" should be for host
pointers.

Paolo
