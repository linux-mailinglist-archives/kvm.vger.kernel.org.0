Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E8631419E4
	for <lists+kvm@lfdr.de>; Sat, 18 Jan 2020 22:38:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727043AbgARVgp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 18 Jan 2020 16:36:45 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:31541 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726957AbgARVgp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 18 Jan 2020 16:36:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579383403;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VPWcmGvI46FzCUX2fOzQ0DbzO3sKFrxZurzvfFdDGjU=;
        b=OcFxEVnpVZTImX4bK5CV6HhWzf5bwaMDJe5xcrHbHsiDWkUgrTs8FZWhFGt1TnU8a4CoEG
        y8H3dhxRCvIcnEXcpfsgEcusanrEXeL2euOrifofrq8DheVA30PZHdcXcFVaYERWBdLTy6
        0skBG2/wERTSt3sGmu4C2sCDPlzrwFk=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-154-kCFVUPSRPDeEl_gtG3d6oQ-1; Sat, 18 Jan 2020 16:36:42 -0500
X-MC-Unique: kCFVUPSRPDeEl_gtG3d6oQ-1
Received: by mail-wr1-f72.google.com with SMTP id i9so12135683wru.1
        for <kvm@vger.kernel.org>; Sat, 18 Jan 2020 13:36:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VPWcmGvI46FzCUX2fOzQ0DbzO3sKFrxZurzvfFdDGjU=;
        b=JkS2qT1XaLBIlVe6tD5wbjq/t/Co4fC6FGyBVgVNgvutq942gHwt+Y2y7AfnDtFKVx
         LjNfDAT3kk4blJTq1H9zGaqoucWE2TwHz+fNMCGnjqPVNsBvYCQXISb0VBFEp761pFe6
         Vi/7OVxkxmUPDm9KdyUTyT+wVKMG+s3Cc4B9vEz0tIs2qcoqkbzhq4p09IXj9DTuKYY5
         Is4vPJGyY9WdxkqYZr67ahUWElfkwW4GRtKlkEy0nhqSX42JnA/YJthqRVxe6P9O0sbH
         0V6Cp+GjDZ3MX9eg7eqTjwEoS4k1LgutcUn/04T4+2hMcZK8bMuAygIe+fci/jS42MQH
         gHng==
X-Gm-Message-State: APjAAAXKNd8Q7p0Mo47upBrQQ5dG1RqOFJXsBLtv7LeZZIXGhQX0ez06
        qLFY34aOkGh1z/1AVjhXWrzKC6Bf+Dw95dba3spCtqSFS97HQbD7rvHAplXRqAUf0arscHvXTnW
        WAJ8weBCwWaNm
X-Received: by 2002:a1c:1dd7:: with SMTP id d206mr11709446wmd.5.1579383401412;
        Sat, 18 Jan 2020 13:36:41 -0800 (PST)
X-Google-Smtp-Source: APXvYqwqF4DDBXto5D6WzyVyaWxWZ2wgDG29D5oOSuWrAns4VYc/b6HpvEMmt4r393uR81aMi/KIsQ==
X-Received: by 2002:a1c:1dd7:: with SMTP id d206mr11709437wmd.5.1579383401182;
        Sat, 18 Jan 2020 13:36:41 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:e0d6:d2cd:810b:30a9? ([2001:b07:6468:f312:e0d6:d2cd:810b:30a9])
        by smtp.gmail.com with ESMTPSA id p26sm15061060wmc.24.2020.01.18.13.36.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Jan 2020 13:36:40 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH v2] x86: Add a kvm module parameter check
 for vmware_backdoors test
To:     Babu Moger <babu.moger@amd.com>
Cc:     kvm@vger.kernel.org
References: <157920400074.15031.16850091609715260458.stgit@naples-babu.amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <612de39f-17a4-5730-86ca-8bcf8f95d124@redhat.com>
Date:   Sat, 18 Jan 2020 22:36:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <157920400074.15031.16850091609715260458.stgit@naples-babu.amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/01/20 20:47, Babu Moger wrote:
> vmware_backdoors test fails if the kvm module parameter
> enable_vmware_backdoor is not set to Y. Add a check before
> running the test.
> 
> Suggested-by: Wei Huang <Wei.Huang2@amd.com>
> Signed-off-by: Babu Moger <babu.moger@amd.com>
> Reviewed-by: Liran Alon <liran.alon@oracle.com>
> ---
> v2: Fixed Wei's name.
>     Added reviwed by Liran Alon.
> 
>  x86/unittests.cfg |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/x86/unittests.cfg b/x86/unittests.cfg
> index 51e4ba5..aae1523 100644
> --- a/x86/unittests.cfg
> +++ b/x86/unittests.cfg
> @@ -164,6 +164,7 @@ check = /proc/sys/kernel/nmi_watchdog=0
>  [vmware_backdoors]
>  file = vmware_backdoors.flat
>  extra_params = -machine vmport=on -cpu host
> +check = /sys/module/kvm/parameters/enable_vmware_backdoor=Y
>  arch = x86_64
>  
>  [port80]
> 

Queued, thanks.

Paolo

