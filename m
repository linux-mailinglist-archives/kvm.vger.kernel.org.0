Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB29117A81E
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 15:51:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726178AbgCEOva (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 09:51:30 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:54965 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725963AbgCEOv3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 5 Mar 2020 09:51:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583419888;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q2h6nPEsw2WQpXjdndQPq3IqLV2vLVlw94U+XC3vi3k=;
        b=CzvnUBWGVZnjd3B/8yl+bSatwjxd3Ig6WG0SdGntbNRgLv1Elta76g9VHBvx9BuOQpqGbF
        cbYBGkHfLl7SUd8lrv7ZpHnqfrrj1yE5TYfDh7LL+3nf7uPp/LiwZHWwNzrIWAat7SS9Kc
        cvEDJY2CkwZ07cCWAyYW27IMIORx0ws=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-107-1dX8urIDMxKeFy2AMAKKeg-1; Thu, 05 Mar 2020 09:51:25 -0500
X-MC-Unique: 1dX8urIDMxKeFy2AMAKKeg-1
Received: by mail-wm1-f71.google.com with SMTP id k65so1665337wmf.7
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2020 06:51:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Q2h6nPEsw2WQpXjdndQPq3IqLV2vLVlw94U+XC3vi3k=;
        b=F77BoAZPdYarOvjh1ekkv6Kso7VQ7sZNuDmpalo32c8lU24oEnYitCnlhwWX5B0zBa
         9ki01CDS44Gu0y0EatdeRDvZmr9efw8Tztr2Ofdq6q8vYyoyNt5SYHfpHnSeOXwfKWJG
         5U/filrLEp1nWk1Z1iMkjcybMyawGA4uLb4EYUf9WVODH3phkhlA/2mXBO/g7UciccXg
         e1gQ9GCT/ntAVjuilmDDlG9s8X1Yr5O+onpHWyaFOR+JCcGaJ3DlYe0HS7RQYPFUB/t+
         u/wIohFu3d8VrhtIacVcZtPynf4hF+oRJpuvWljcQMGZMXCtsh89swGNhOUK09izQqC7
         FFeA==
X-Gm-Message-State: ANhLgQ3yhyXqeaFAcqiXd9Vft+BmzGI6HXTVYUOn9JLDgwJZMfLxnGrW
        ATomdJCC281K5650CwMEOel1FIV5I2zsjxQhhEZVWe+PmC/Ed2rVGitc8a/jqHEpPxSVPNHYETs
        K4orQqmlYczcK
X-Received: by 2002:adf:db84:: with SMTP id u4mr10772015wri.317.1583419884802;
        Thu, 05 Mar 2020 06:51:24 -0800 (PST)
X-Google-Smtp-Source: ADFU+vtTRxo3t5rJ55MDnIHanJNHGJWt5oHjPPR6NBeyxl0zG2Vh2C3V07dfWyE02Tr41RF7mTuCEA==
X-Received: by 2002:adf:db84:: with SMTP id u4mr10771941wri.317.1583419883699;
        Thu, 05 Mar 2020 06:51:23 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:9def:34a0:b68d:9993? ([2001:b07:6468:f312:9def:34a0:b68d:9993])
        by smtp.gmail.com with ESMTPSA id 12sm9559704wmo.30.2020.03.05.06.51.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Mar 2020 06:51:23 -0800 (PST)
Subject: Re: [PATCH v9 1/7] KVM: CPUID: Fix IA32_XSS support in CPUID(0xd,i)
 enumeration
To:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jmattson@google.com,
        sean.j.christopherson@intel.com
Cc:     yu.c.zhang@linux.intel.com
References: <20191227021133.11993-1-weijiang.yang@intel.com>
 <20191227021133.11993-2-weijiang.yang@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <bd75450f-a929-f60b-e973-205e4f5a9743@redhat.com>
Date:   Thu, 5 Mar 2020 15:51:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20191227021133.11993-2-weijiang.yang@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/12/19 03:11, Yang Weijiang wrote:
> +	u64 (*supported_xss)(void);

I don't think the new callback is needed.  Anyway I'm rewriting this
patch on top of the new CPUID feature and will post it shortly.

Paolo

