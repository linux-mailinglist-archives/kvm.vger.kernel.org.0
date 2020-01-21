Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52E6B143CA7
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2020 13:20:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728760AbgAUMUt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jan 2020 07:20:49 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:44373 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727817AbgAUMUs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jan 2020 07:20:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579609247;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lBZ+inyQ+++w+9TWTNYwvJFiFZJEnd4G9PneIHAZ4Zo=;
        b=OihuDbxNLtjWIfflbvFEFUBNFXPmzU1ZP2McpMHJHtC9PF9zJEQXTWR1kHodTvsKdr72L7
        wA/X/Ki5OZXgwWk1uIBXlyTtBH2tF7qcE2MlRBA6dkG1jvBZgbtPasnIZUDJC16TwHMVBZ
        NS3vC9cVrWddqXOsxq8YW5EfK/3g7Zg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-98-7-zoD1MQP861TzBVWmbMsA-1; Tue, 21 Jan 2020 07:20:46 -0500
X-MC-Unique: 7-zoD1MQP861TzBVWmbMsA-1
Received: by mail-wm1-f70.google.com with SMTP id g26so347711wmk.6
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2020 04:20:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lBZ+inyQ+++w+9TWTNYwvJFiFZJEnd4G9PneIHAZ4Zo=;
        b=BQ225qCnYfGFXzRyIHZicdKS/BVTp/rfksyOl9nWc+/VkKL6zjlQizykFnnLHA4yiV
         oq9efZL5mu4pmspbKViFWA5sg7pa5DuwGrhYy8WMvToOIQXBUyxeRuXZwpCYxD6JDHcG
         i8D0W+oGXIjWQqg7FUhinYDRlX3MZ5Bb1Q8ztIdxm6DOPaSrYIfrbvjpSalCXsi9dFFc
         E2Qq+sIsa2+HGrsIFeE1UOMve1nfdMLb4XRxMDEorxJU7hfFhcxBjSFqP0lxlPNZivic
         u2WQybWLvo0UrYU87jkYATmJxBLnlQ10leEtbxy+QglNSeWylK57IWeoks4T+UNbN9N1
         HxLw==
X-Gm-Message-State: APjAAAVNjzWemJVdPBwOwQMeYL0sFFMliw3EiD/8FTIc49KadutNYMTC
        Vl8SkwWuY0kZujmijgD4+PRUd7pk85vPjIyGRIqPiEQ79nA4zuDvPH38j6pM11Ipn+maLujnLEZ
        VgI7ubJfskxqw
X-Received: by 2002:a5d:6a10:: with SMTP id m16mr4907975wru.411.1579609245045;
        Tue, 21 Jan 2020 04:20:45 -0800 (PST)
X-Google-Smtp-Source: APXvYqz21yMxycJbSGWJJqHST4KZlDHZfAsrVBs8QsprBfaoVfWMU+edgU+bPicmH1fkjBl0AfT37A==
X-Received: by 2002:a5d:6a10:: with SMTP id m16mr4907949wru.411.1579609244714;
        Tue, 21 Jan 2020 04:20:44 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:b509:fc01:ee8a:ca8a? ([2001:b07:6468:f312:b509:fc01:ee8a:ca8a])
        by smtp.gmail.com with ESMTPSA id w83sm3697720wmb.42.2020.01.21.04.20.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2020 04:20:44 -0800 (PST)
Subject: Re: [kvm-unit-tests v2 1/2] README: Fix markdown formatting
To:     Andrew Jones <drjones@redhat.com>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>
Cc:     kvm@vger.kernel.org
References: <20200120194310.3942-1-wainersm@redhat.com>
 <20200120194310.3942-2-wainersm@redhat.com>
 <20200121091838.caxeirc4aymxdnwc@kamzik.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a130d934-e562-02e2-14c1-f3b60126ff7e@redhat.com>
Date:   Tue, 21 Jan 2020 13:20:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200121091838.caxeirc4aymxdnwc@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/01/20 10:18, Andrew Jones wrote:
> Besides the space before 'Any' this patch is fine, which is why I gave the
> r-b. I can do a reformatting patch on top of this myself for my other
> comments. However if you're going to respin this, then please consider
> reformatting the line lengths and the sentence punctuation. Also please
> changing occurrences of "qemu" and "kvm" to "QEMU" and "KVM" when they are
> being used as names, rather than parts of paths. E.g.
> 
>  The KVM test suite is in kvm-unit-tests.
>  We can run QEMU with qemu-system-x86_64.

Applied the suggested tweaks and queued, thanks to both of you!

Paolo

