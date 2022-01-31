Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39B994A4936
	for <lists+kvm@lfdr.de>; Mon, 31 Jan 2022 15:22:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232149AbiAaOWV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jan 2022 09:22:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231178AbiAaOWV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jan 2022 09:22:21 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9575C061714;
        Mon, 31 Jan 2022 06:22:20 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id u15so25765714wrt.3;
        Mon, 31 Jan 2022 06:22:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=epZCgtRDGQmeZnI22oh+prdRoR4meGsNZ1G4F0nBuuM=;
        b=D8nxhTyhA1svClYRBCifjcmjBPll4xh40nG3vU02PFtBqk2yUXb/MvUBspIM1OuylZ
         3bTbr6L8ip2wkWPSfmWnnwhkaFk1CaBH0b8g2ezphXwayKDkK0TS5x65zFnoJF++MRCp
         dfox9M9sk7kKE5RFfi0RxOYGrsRKYsihBIz4mJdtvhe4j+P6AIOwrEKJRXVeTs60KN94
         URBWNdcSmgOPX+d/Oy6GEZGBt2gpI7gOpoQRTtSsosiLdWqI+rXi1Hu4ofrfpBIwYWyn
         q+I34GPwIQ6ABk7Lwg9qwMpP+PY574gwxiLXS1uOro5p9xGisaHcpmsRmSNYBPCqhbfM
         Ogdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=epZCgtRDGQmeZnI22oh+prdRoR4meGsNZ1G4F0nBuuM=;
        b=BhRbtUWHFDnZ4n1psJAAoHJi+CbsIIzFf9JHolljKb3owl4LhH1wIBd1TWxiKmX9dO
         282qmkfI1O6P2HyFqXryGL+78L+OOXk8MHPDzb/8N5INJol/wnyGM1Jb291Jydh3S+O0
         ooVVc4XUYhlxibWnH/eqJsTTfQ27/vyfbwM4Ovriti9lvzXKtN9tVGln4GIE0LYWkkf+
         WDOgul39b/dZksrldTw4l6XN6ykFS9QbiXO9Wep1hKZoNsm7XTtKIEzX9DYkJ3RnXea4
         eRIpw1aoeTPPMhJilnqQM+T4kmyNm18TgxRndFgjzYK0c9n6KteD4c1dzgl/CF9Mb5QR
         W+9Q==
X-Gm-Message-State: AOAM5316PgrdEX9h3WKGpGbJY2tCdItIvwH1RVKeEIUCITlrPgpgi8Oo
        rZklhVuKbxq8Z0A0RVL1o6QGjz+Ptoc=
X-Google-Smtp-Source: ABdhPJwt2j3IKptHM8KFnTXa7Q1gjquSm9HfdHDFX0qMW9IQNq16gP60qpMuzW4XbuggwI3v5BVQKQ==
X-Received: by 2002:a5d:60c5:: with SMTP id x5mr17551684wrt.376.1643638938993;
        Mon, 31 Jan 2022 06:22:18 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id y3sm13619535wry.109.2022.01.31.06.22.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Jan 2022 06:22:18 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <8396dda5-d82c-8b5d-f94e-28ba84ec422d@redhat.com>
Date:   Mon, 31 Jan 2022 15:22:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] kvm: Move KVM_GET_XSAVE2 IOCTL definition at the end of
 kvm.h
Content-Language: en-US
To:     Janosch Frank <frankja@linux.ibm.com>, linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, guang.zeng@intel.com, jing2.liu@intel.com,
        kevin.tian@intel.com, seanjc@google.com, tglx@linutronix.de,
        wei.w.wang@intel.com, yang.zhong@intel.com
References: <20220128154025.102666-1-frankja@linux.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220128154025.102666-1-frankja@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/28/22 16:40, Janosch Frank wrote:
> This way we can more easily find the next free IOCTL number when
> adding new IOCTLs.
> 
> Fixes: be50b2065dfa ("kvm: x86: Add support for getting/setting expanded xstate buffer")
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>   include/uapi/linux/kvm.h | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 9563d294f181..efe81fef25eb 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1623,9 +1623,6 @@ struct kvm_enc_region {
>   #define KVM_S390_NORMAL_RESET	_IO(KVMIO,   0xc3)
>   #define KVM_S390_CLEAR_RESET	_IO(KVMIO,   0xc4)
>   
> -/* Available with KVM_CAP_XSAVE2 */
> -#define KVM_GET_XSAVE2		  _IOR(KVMIO,  0xcf, struct kvm_xsave)
> -
>   struct kvm_s390_pv_sec_parm {
>   	__u64 origin;
>   	__u64 length;
> @@ -2047,4 +2044,7 @@ struct kvm_stats_desc {
>   
>   #define KVM_GET_STATS_FD  _IO(KVMIO,  0xce)
>   
> +/* Available with KVM_CAP_XSAVE2 */
> +#define KVM_GET_XSAVE2		  _IOR(KVMIO,  0xcf, struct kvm_xsave)
> +
>   #endif /* __LINUX_KVM_H */

Queued, thanks.
