Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8267A32D5B5
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 15:57:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbhCDO4U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Mar 2021 09:56:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:23974 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229637AbhCDO4F (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Mar 2021 09:56:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614869679;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xr+0xjbR8wujVaSiREj96vjfeZy56B32moH25XWztBo=;
        b=XUtReQOez1dg2/qOnmFKNmV7Sn0Mx3dKJ+RD2dj35/e8ujN9UtPkEUjIsI3YgvGIKykTs1
        stbOjRBU/ch4oxefbz+JYbqahJQZ4fu+zstVB0yPpE5AL62fOrAyjxdEDfmJtNOmCGsNKm
        e8HbD/lzlcWlNlvpijx1CALOhq/oMm8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-222-9YsScbcAOKmFQulRblWN1Q-1; Thu, 04 Mar 2021 09:54:38 -0500
X-MC-Unique: 9YsScbcAOKmFQulRblWN1Q-1
Received: by mail-wr1-f69.google.com with SMTP id z6so5769653wrh.11
        for <kvm@vger.kernel.org>; Thu, 04 Mar 2021 06:54:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xr+0xjbR8wujVaSiREj96vjfeZy56B32moH25XWztBo=;
        b=msfG8niMu3IftSxsplae6xhVp8qYCZN2PaToDEAjhuyHfKkAlz2EQpkexiKAhy5MzF
         uV9PaXzZTz32RnTXJGaGhgKztNv2TjTyEFbuwLCig+h4uFM74GJGWXrqV29yoIzL/QrO
         ci45TEdqkgQV+j1/+zQ30dd2W7adrsxc4RyxbpiFEXt6axlQzs595urr2Y5KiyxriJOS
         M3IoFMaPcU6gTxCwz/k26K1/SIH+nXG0etPDpwP9be/Y2xjAaLduTKLojLWXQhE2x1vz
         BOYqz8s8mtYfVyPnn+EYsbCqg5m/OU3/OgDBATphmQQMLYeVu3FgZ4PkdhirY3H5Nxef
         pC5g==
X-Gm-Message-State: AOAM531i22vU5oqF5m5JN013ZutnQ4PkWn913WszPJ1fOnr9ZQ3bMXAo
        edW5GmHlHgWJcmJ0vEGVqPsXE4ONraxm6WRHK9EsbF3Gxgglu1A4wy0pXEddZlekPvNOp+w3R8i
        323MK0/VnxxrT
X-Received: by 2002:a1c:1f04:: with SMTP id f4mr4480685wmf.12.1614869676913;
        Thu, 04 Mar 2021 06:54:36 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwkvaeX62cIP49GRybRrBdkH5Eb5lkzjIfeG7/sCFGKZ5uRMBXqFUsG+t1YjvIFMgWx4AyviA==
X-Received: by 2002:a1c:1f04:: with SMTP id f4mr4480671wmf.12.1614869676729;
        Thu, 04 Mar 2021 06:54:36 -0800 (PST)
Received: from [192.168.1.36] (68.red-83-57-175.dynamicip.rima-tde.net. [83.57.175.68])
        by smtp.gmail.com with ESMTPSA id w6sm16059433wrl.49.2021.03.04.06.54.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Mar 2021 06:54:36 -0800 (PST)
Subject: Re: [RFC PATCH 00/19] accel: Introduce AccelvCPUState opaque
 structure
To:     Paolo Bonzini <pbonzini@redhat.com>, qemu-devel@nongnu.org
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
 <a84ce2e5-2c4c-9fce-d140-33e4c55c5055@redhat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <1eda0f3a-1b11-a90e-8502-cf86ef91f77e@redhat.com>
Date:   Thu, 4 Mar 2021 15:54:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <a84ce2e5-2c4c-9fce-d140-33e4c55c5055@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/4/21 2:56 PM, Paolo Bonzini wrote:
> On 03/03/21 19:22, Philippe Mathieu-Daudé wrote:
>> Series is organized as:
>> - preliminary trivial cleanups
>> - introduce AccelvCPUState
>> - move WHPX fields (build-tested)
>> - move HAX fields (not tested)
>> - move KVM fields (build-tested)
>> - move HVF fields (not tested)
> 
> This approach prevents adding a TCG state.  Have you thought of using a
> union instead, or even a void pointer?

Why does it prevent it? We can only have one accelerator per vCPU.

TCG state has to be declared as another AccelvCPUState implementation.

Am I missing something?

Preventing building different accelerator-specific code in the same
unit file is on purpose.

Regards,

Phil.

