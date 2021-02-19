Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A15531FDFD
	for <lists+kvm@lfdr.de>; Fri, 19 Feb 2021 18:39:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbhBSRiX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Feb 2021 12:38:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47011 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229555AbhBSRiU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Feb 2021 12:38:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613756213;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/iQIYzCUzufPYt+TLigNIgms1BaZgh18m0vewYul3GY=;
        b=TXh0h/czXA/+ivAXl+6V2ZCkfqbG14iPb+muqGGWrZp8MDUAvLGPFEFjGt0fGElQwW3jwQ
        DEXA/1kkd8sZAssgY9W434C3lzaO84LG6drhFFiYccwvIU3ab8rwRYcJBGWS8t1S6pYKHe
        aYXekDB53Wm82vgweLo/ZtVz6WW1yoI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-280-0yb0LTFuNR2pZj2RJwPKCw-1; Fri, 19 Feb 2021 12:36:52 -0500
X-MC-Unique: 0yb0LTFuNR2pZj2RJwPKCw-1
Received: by mail-wr1-f70.google.com with SMTP id w11so2791143wrp.6
        for <kvm@vger.kernel.org>; Fri, 19 Feb 2021 09:36:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/iQIYzCUzufPYt+TLigNIgms1BaZgh18m0vewYul3GY=;
        b=VmUumt7T1yrcKVqQxqoL4Rh9fNVgWoI2Oaxy9/NHcCc+8DZylsyiKIAHoIdgcnyynT
         U6+9v60+jByvbeUxoCkVo2R5ACFswqEg+WKfmKYbozXXat+5SpUvoLtu/yAOF1LalQst
         An4zmCegGlErafWsmxC0RKsMLsNHkvS0W25AlTM6lwtAd0OIxyLnuFtv0x8aN8aoFVhL
         ogvM5fNknNnwLYrqvBAvm0/cs+3BTqaa511FVc3ALVSJmP/POouavYdzGQJM8gff5oRT
         IZEZBDg7z8cfVwokJ2C/fg9A8dLLYn5paQvqckpjlUfkiRSBvt4nZr4jv97xc5n1atqR
         tvDA==
X-Gm-Message-State: AOAM531HpMYs1VsneJ7xkOAnWq2iEk+pp6rjypp4UvK1m2j/4s6HNxzB
        QPWN15EG1NFeh4HbqlT8De7CmejxLU95QcINzO/M6Tx2Ow4nJSNc9ljyR3BwJehXU8PUJT21DX7
        Ui8zQI66sG/fH
X-Received: by 2002:a1c:ac82:: with SMTP id v124mr9187700wme.97.1613756210959;
        Fri, 19 Feb 2021 09:36:50 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw1t3OYyj9ULAD5Jdke9RJ2GfDldlNhOzx1kIRp9/MAkNqEbwllnGX+7Y7ooPgmeGzNQ67jGw==
X-Received: by 2002:a1c:ac82:: with SMTP id v124mr9187679wme.97.1613756210811;
        Fri, 19 Feb 2021 09:36:50 -0800 (PST)
Received: from [192.168.1.36] (68.red-83-57-175.dynamicip.rima-tde.net. [83.57.175.68])
        by smtp.gmail.com with ESMTPSA id k15sm12593212wmj.6.2021.02.19.09.36.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Feb 2021 09:36:50 -0800 (PST)
Subject: Re: [PATCH 0/7] hw/kvm: Exit gracefully when KVM is not supported
To:     Claudio Fontana <cfontana@suse.de>, qemu-devel@nongnu.org
Cc:     Peter Maydell <peter.maydell@linaro.org>,
        Radoslaw Biernacki <rad@semihalf.com>, kvm@vger.kernel.org,
        David Hildenbrand <david@redhat.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Thomas Huth <thuth@redhat.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        =?UTF-8?Q?Herv=c3=a9_Poussineau?= <hpoussin@reactos.org>,
        Leif Lindholm <leif@nuviainc.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Alistair Francis <alistair@alistair23.me>,
        Richard Henderson <richard.henderson@linaro.org>,
        Greg Kurz <groug@kaod.org>, qemu-s390x@nongnu.org,
        qemu-arm@nongnu.org, David Gibson <david@gibson.dropbear.id.au>,
        Cornelia Huck <cohuck@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-ppc@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>
References: <20210219114428.1936109-1-philmd@redhat.com>
 <89bb6db0-0411-e219-3df8-8300664b54f3@suse.de>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <e59f2ee6-b438-5dc8-d236-adc9b5e22988@redhat.com>
Date:   Fri, 19 Feb 2021 18:36:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <89bb6db0-0411-e219-3df8-8300664b54f3@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/19/21 1:34 PM, Claudio Fontana wrote:
> On 2/19/21 12:44 PM, Philippe Mathieu-Daudé wrote:
>> Hi,
>>
>> This series aims to improve user experience by providing
>> a better error message when the user tries to enable KVM
>> on machines not supporting it.
>>
>> Regards,
>>
>> Phil.
> 
> Hi Philippe, not sure if it fits in this series,
> 
> but also the experience of a user running on a machine with cortex-a72,
> choosing that very same cpu with -cpu and then getting:
> 
> qemu-system-aarch64: kvm_init_vcpu: kvm_arch_init_vcpu failed (0): Invalid argument
> 
> is not super-friendly. Maybe some suggestion to use -cpu host with KVM could be good?

I agree this should be improved, but it is out of the scope of this
series :)

