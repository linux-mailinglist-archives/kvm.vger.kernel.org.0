Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 202D8415AFF
	for <lists+kvm@lfdr.de>; Thu, 23 Sep 2021 11:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240157AbhIWJe2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Sep 2021 05:34:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45036 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240138AbhIWJe1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Sep 2021 05:34:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632389575;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vQ7gNADpFGwqFnkHyhF4jJ6Rt7/8bjPgrHcSPOjO4AA=;
        b=BncSmElukHWzVVeuR1ZBTyZga7i0kxW5lsd8u7OuQruqpCM2HfEb3ylFL7bj7n0YP8+PbB
        bu9us9+74iiY/WIX8Kn0ars32z3dAUFxXlKNXBTeO/BhuH+1pLDDZBM+1SthGhSXaIvten
        ZxDCPs/0xf1OiBXctgKx3+WWWQxioFM=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-575-ukN49W1ONwi1S22lVV7mXA-1; Thu, 23 Sep 2021 05:32:51 -0400
X-MC-Unique: ukN49W1ONwi1S22lVV7mXA-1
Received: by mail-ed1-f69.google.com with SMTP id w24-20020a056402071800b003cfc05329f8so6177543edx.19
        for <kvm@vger.kernel.org>; Thu, 23 Sep 2021 02:32:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vQ7gNADpFGwqFnkHyhF4jJ6Rt7/8bjPgrHcSPOjO4AA=;
        b=4ZPwFovOeA2K0Za4iJlXVv+MsgB6dgkFu9CVW8AgRYAPJk5Q3gCCreLpmgeSxpapbt
         Z1jg+mYpXiQ12z5jTpZknLZdhoUCGY5WlcR4LFN8v66RiSAEH75KQU8Ti30PEvxvQ3cQ
         Kt44Q3MieWISXT5amP/pC3W+sdJczrm/HC+PyFSaEcCIiO+6hhwdixRGdBIZbXB/4roq
         wufr8FVmg8LDDfifZhFavFUGPtqplF0gCcwGMBl8y/KmzFtphosTzeaOlPu/TBBMVK4j
         K0c+Fu1FmxeF3NwDoQQw9wbYXx6Pnht0Z39OnkiwxUxSDcieywrRNeDwdAOSURYEHKar
         Ad3w==
X-Gm-Message-State: AOAM532zYVfYK4Q6PPTtz60StvvxJUgls6V3/iI7XpvwNAZ7vlgfvsBT
        dmYxbteOWNJkeF+zaWZu7URRyfYd6aadacmSy3Sju5Nqxs876MEzldc3lrVjjWfiZEWPe270Mje
        CMsZe7ifIu+Of
X-Received: by 2002:a17:907:76b2:: with SMTP id jw18mr4054551ejc.120.1632389570544;
        Thu, 23 Sep 2021 02:32:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyj741KcyNzkcGTBSDMtqoi+OLODRHTnqzbT/m13qxom8hUQFpy/xul3Ey/KmcWUUbkr8cevg==
X-Received: by 2002:a17:907:76b2:: with SMTP id jw18mr4054539ejc.120.1632389570329;
        Thu, 23 Sep 2021 02:32:50 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id s3sm2737094ejm.49.2021.09.23.02.32.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Sep 2021 02:32:49 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] x86/msr.c generalize to any input msr
To:     Alexander Graf <graf@amazon.com>,
        yqwfh <amdeniulari@protonmail.com>, kvm@vger.kernel.org
Cc:     Daniele Ahmed <ahmeddan@amazon.com>,
        Thomas Huth <thuth@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Andrew Jones <drjones@redhat.com>
References: <20210810143029.2522-1-amdeniulari@protonmail.com>
 <08d356da-17ce-d380-1fc9-18ba7ec67020@amazon.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7d43d0a8-89e0-f9b1-37de-621e529a2d3b@redhat.com>
Date:   Thu, 23 Sep 2021 11:32:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <08d356da-17ce-d380-1fc9-18ba7ec67020@amazon.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/09/21 11:11, Alexander Graf wrote:
> Usually, get_maintainers.pl should extract that list automatically for 
> you but I realized that there is no such file in the kvm-unit-tests tree 
> even though we have a MAINTAINERS one.
> 
> Paolo, what is the method you'd prefer to determine who to CC on 
> kvm-unit-tests submissions?

Let's add a get_maintainers.pl script.  We might also start accepting 
merge requests on gitlab though...

Paolo

