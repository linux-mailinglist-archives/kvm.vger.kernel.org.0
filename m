Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88F2A17782B
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 15:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729263AbgCCODy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Mar 2020 09:03:54 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:54330 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726899AbgCCODy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Mar 2020 09:03:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583244233;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ceaj2Lg7fPNdB8HydaqL4RB3izyCaF2LynvqRf8Tl8U=;
        b=EDdqHmGv9WfYR01SjSjm6LnBW9CtyN+c5M7W/RtyH46vUj7bk+iJftnx64Cc7oJWN1UzJX
        a3RPyLEQIoo+fThhMAw4/V54hEZZw+f5rMmRa9h5CaiZHIMlcvj/SCjGb02k2dvnZXq57a
        nC8Ga2EF1sjPdT8ZQIuXUoVN31emeuQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-1-0IgMFf0_OxK0La6MeCremA-1; Tue, 03 Mar 2020 09:03:51 -0500
X-MC-Unique: 0IgMFf0_OxK0La6MeCremA-1
Received: by mail-wr1-f69.google.com with SMTP id w8so469557wrn.7
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2020 06:03:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ceaj2Lg7fPNdB8HydaqL4RB3izyCaF2LynvqRf8Tl8U=;
        b=hOMXqN3NysVpJAul/V5crnFEA7WVpcM08r4ftl/4jt4n0neQMRTRPxU9qK6Yd+7Bo3
         VO6T6qAjizkosLzzeZBh+SIKc0P/1D3C+FTeTkD/ltD/rcpGn5zHVYnvQlyieIPPkybZ
         CebFnBgHL4Fqb9Y9646QEDrslYJsuw2XYufvY0/qqZVLtVSnCvc19YGOBfzPb4MRBMtA
         +wdSHzOpc7CRziV5ZKCVeDFY7I+sl8QfoqDLFprh3oLPf7D+Em+TAbytLuRE6kYMQbBk
         kBPYUppyqozkxevDq6WJ48d7nfRrQQ9Eb1DPQJy9k3n1X1AhS5AdR+GfCWvjZ/HmbvfJ
         PDIw==
X-Gm-Message-State: ANhLgQ09WWb0vwlEt6oWywpBl9Xh2bTx73VAuLxByxGUIkzzqJ7ztWjS
        nU91FnY+oci3mssab21u30m3yTErGtIOgsaEMCY7jX6tZviZgvW7WW6PY11pVK3CJpt8c9mJy1K
        U+HnyR/X5g/Wy
X-Received: by 2002:adf:b609:: with SMTP id f9mr5238256wre.380.1583244230110;
        Tue, 03 Mar 2020 06:03:50 -0800 (PST)
X-Google-Smtp-Source: ADFU+vtRrjACbBzLECzEdikELeWu5riMzPojCsiwMy3rUBXbMXTxIm4JJhpHv89LsfdGxx108rVeSA==
X-Received: by 2002:adf:b609:: with SMTP id f9mr5238244wre.380.1583244229878;
        Tue, 03 Mar 2020 06:03:49 -0800 (PST)
Received: from [192.168.178.40] ([151.20.254.94])
        by smtp.gmail.com with ESMTPSA id j14sm34519090wrn.32.2020.03.03.06.03.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Mar 2020 06:03:49 -0800 (PST)
Subject: Re: [PATCH v3 18/18] docs: kvm: get read of devices/README
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
References: <cover.1583243826.git.mchehab+huawei@kernel.org>
 <6e9c4aaf704cdc7b4e517122fb87cbe05f0ffd23.1583243827.git.mchehab+huawei@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ef0e7454-d7ff-2dcb-194d-b8b831769eac@redhat.com>
Date:   Tue, 3 Mar 2020 15:03:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <6e9c4aaf704cdc7b4e517122fb87cbe05f0ffd23.1583243827.git.mchehab+huawei@kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/03/20 14:59, Mauro Carvalho Chehab wrote:
> Add the information there inside devices/index.rst
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> ---
>  Documentation/virt/kvm/devices/README    | 1 -
>  Documentation/virt/kvm/devices/index.rst | 3 +++
>  2 files changed, 3 insertions(+), 1 deletion(-)
>  delete mode 100644 Documentation/virt/kvm/devices/README
> 
> diff --git a/Documentation/virt/kvm/devices/README b/Documentation/virt/kvm/devices/README
> deleted file mode 100644
> index 34a69834124a..000000000000
> --- a/Documentation/virt/kvm/devices/README
> +++ /dev/null
> @@ -1 +0,0 @@
> -This directory contains specific device bindings for KVM_CAP_DEVICE_CTRL.
> diff --git a/Documentation/virt/kvm/devices/index.rst b/Documentation/virt/kvm/devices/index.rst
> index 192cda7405c8..cbadafc0e36e 100644
> --- a/Documentation/virt/kvm/devices/index.rst
> +++ b/Documentation/virt/kvm/devices/index.rst
> @@ -4,6 +4,9 @@
>  Devices
>  =======
>  
> +The following documentation contains specific device bindings
> +for KVM_CAP_DEVICE_CTRL.
> +
>  .. toctree::
>     :maxdepth: 2
>  
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

