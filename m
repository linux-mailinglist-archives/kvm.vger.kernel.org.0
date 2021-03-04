Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB2032D4BB
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 14:59:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231736AbhCDN6n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Mar 2021 08:58:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37320 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231670AbhCDN6N (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Mar 2021 08:58:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614866207;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MpHX/a7yCBReDRTGDYwwyxBKDLq55HbfjE9ITkwtBBE=;
        b=gzCsrWqSVBsJ0KZrmgOpfTApoFKqOs+7yMsbQVv4PW/SSWLtqnKKomeDtaENltp1w8+CCs
        Iclf5oZw3UbgotSQ3uSAbeiJM7XAgEuWURbfgo8iyb3hFZzBDveSUVFKTRP69SbVqYKQfa
        7k8IN/bEi3qqwWJgf+AmbDb0FvZSUeA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-369-RRTtnLxHPGGpRcshMO37EA-1; Thu, 04 Mar 2021 08:56:46 -0500
X-MC-Unique: RRTtnLxHPGGpRcshMO37EA-1
Received: by mail-wr1-f69.google.com with SMTP id g2so7546173wrx.20
        for <kvm@vger.kernel.org>; Thu, 04 Mar 2021 05:56:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MpHX/a7yCBReDRTGDYwwyxBKDLq55HbfjE9ITkwtBBE=;
        b=WKEi5XoNdLiEWDM6pmKWEXXsIfRizBl73Y0s51LOF7SX2nDa5zbrVr+/ZpFwBB8lKw
         oO+W4zw81N0wy+YpqnBr9B4Z1oor7wdUc10+vSLY9KztX+cn8zYogu+6c/XMtJYyx5ke
         eAlGNFoSeVkspeiH9HL0IpoGQ69Ou2mCPRPyAGBdWzPxaZjl3YcghYvlc6XWwUg3ZHP0
         WWZZrdreCcdTHkRQ4oLNiEDII8U7qUCz+dWm6Y4GTp+h+aBNjd3ZiErqToSSeXyb1q3P
         RJA1daLF2MrE6t7Wc063JKT1kTilvtMTAKr+lT2GkxGe7OaoqHIpbJFDzCx0KT0kI39E
         BrUQ==
X-Gm-Message-State: AOAM532APxc/FwlwpRdigLXo56lOwwjN0RMabr/tcXTBp4T+uVQRW798
        iUgx4k67tHBpbohA81TPNoKAHu8iLUQlySBgHKok6YeclX0oV+Bam/7MEXCHYYNe9vLWetE5KTz
        6lo9wT4gdGgf9
X-Received: by 2002:a7b:c041:: with SMTP id u1mr4049883wmc.161.1614866204899;
        Thu, 04 Mar 2021 05:56:44 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwYGR8bnjcT7LzAXU8tRW/khqIFgYtcWtTCkFEJV0OxsrH10KzYftCakpHiJpw9Zqs1Dxhs7Q==
X-Received: by 2002:a7b:c041:: with SMTP id u1mr4049856wmc.161.1614866204738;
        Thu, 04 Mar 2021 05:56:44 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id h20sm9649878wmp.38.2021.03.04.05.56.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Mar 2021 05:56:44 -0800 (PST)
Subject: Re: [RFC PATCH 00/19] accel: Introduce AccelvCPUState opaque
 structure
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org
Cc:     Eduardo Habkost <ehabkost@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        kvm@vger.kernel.org, Wenchao Wang <wenchao.wang@intel.com>,
        Thomas Huth <thuth@redhat.com>,
        Cameron Esfahani <dirty@apple.com>,
        David Hildenbrand <david@redhat.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Greg Kurz <groug@kaod.org>, qemu-arm@nongnu.org,
        Halil Pasic <pasic@linux.ibm.com>,
        Colin Xu <colin.xu@intel.com>,
        Claudio Fontana <cfontana@suse.de>, qemu-ppc@nongnu.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        qemu-s390x@nongnu.org, haxm-team@intel.com
References: <20210303182219.1631042-1-philmd@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a84ce2e5-2c4c-9fce-d140-33e4c55c5055@redhat.com>
Date:   Thu, 4 Mar 2021 14:56:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210303182219.1631042-1-philmd@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/03/21 19:22, Philippe Mathieu-Daudé wrote:
> Series is organized as:
> - preliminary trivial cleanups
> - introduce AccelvCPUState
> - move WHPX fields (build-tested)
> - move HAX fields (not tested)
> - move KVM fields (build-tested)
> - move HVF fields (not tested)

This approach prevents adding a TCG state.  Have you thought of using a 
union instead, or even a void pointer?

Paolo

