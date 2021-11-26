Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33FE745F507
	for <lists+kvm@lfdr.de>; Fri, 26 Nov 2021 20:08:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233361AbhKZTL7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Nov 2021 14:11:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231672AbhKZTJ5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Nov 2021 14:09:57 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA251C0619D3
        for <kvm@vger.kernel.org>; Fri, 26 Nov 2021 10:31:46 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id i12so8834380wmq.4
        for <kvm@vger.kernel.org>; Fri, 26 Nov 2021 10:31:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=uktXa8zbKhf+Fv6LYUqzRYdKvf4sFyeirZ3veeH9bHo=;
        b=Mi+tObMx7+sdFRHmYawfKqgjHfnkHBuaPLDdptGyq2Chp2E1jO0PQTlSnWZwbFXbWv
         Q0fCRMiIE08PggoozJWvZ7E18yyqdQG3qcbhtZXOxRuuiyoKiWUYFvjdipFGhp5pJQ08
         sxOOf0s1ogrlHbLiB7RgBB7G49WXWR+EHSMWzjUjqQwv0xc3ZxJwYn2IkOo3KohXSvJh
         gUveUROWqPtPryy3KU5D95MoCdFmIbp+QL/n/vfOcDGwz03bB0bOfWqpCbzXQf+QKb8L
         /00wqAT7MFE7Nk1s8xUMuq1eICyNiEtlj48GYQnmI4h16QxgqZ5gJe43fMyKnz70mYY7
         89KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=uktXa8zbKhf+Fv6LYUqzRYdKvf4sFyeirZ3veeH9bHo=;
        b=M1aIclsmRoWA4OCriyEJb9vuDJEn+ax6pJPxi5VYr5txJ+uJPqOLocbYhrVhtFNFCv
         MaC8bL5MzCq9PxSnyEE3sTAzodY2vh9E5OcHrEe/WgxUXwCQEG0OSV79W/71SQkgbSn3
         HmMzGJU6sXij4XBhsi8wzl5m9VgiN+eyM2dDPar3CLQP9eeY3iJtNd7gPWX2dK6b80ul
         sy/y+XYh1IUL0eUwbMJp8zF/wRLGC3NLi3YiVeWFR3dUGoG3PC1MMr0mq+IZ1nGQc3ID
         e3pK0lG7E6nWwHMNFsXT2xAuHJFrMLF8zaE9RqgxJqfQW7hocqsh7bs+ZORh/pZeqCMX
         k9tA==
X-Gm-Message-State: AOAM533DhAfdPA9gsjYHIKTCAGOXnZMAPCpBqZZqKsIQQbPxfSfYlO2J
        d3oRHEWMmWupQ1vefSRc9Ig=
X-Google-Smtp-Source: ABdhPJxYkDe69yZG+aaGdYDbKvSq+jmkodFX05ZNrUURxu4DrArZJRFTTTm9yuPE6drsTUZLwbAPEg==
X-Received: by 2002:a05:600c:4153:: with SMTP id h19mr17683019wmm.142.1637951505319;
        Fri, 26 Nov 2021 10:31:45 -0800 (PST)
Received: from ?IPV6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.googlemail.com with ESMTPSA id 9sm8221876wry.0.2021.11.26.10.31.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Nov 2021 10:31:45 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <40a32167-6b19-f47d-03f8-a7e95f8e39f9@redhat.com>
Date:   Fri, 26 Nov 2021 19:31:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [kvm-unit-tests PATCH 34/39] nVMX: Fix name of macro defining EPT
 execute only capability
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org
References: <20211125012857.508243-1-seanjc@google.com>
 <20211125012857.508243-35-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211125012857.508243-35-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/25/21 02:28, Sean Christopherson wrote:
> Rename EPT_CAP_WT to EPT_CAP_EXEC_ONLY.  In x86, "WT" generally refers to
> write-through memtype, and is especially confusing considering that EPT
> capabilities also report UC and WB memtypes.
> 
> Signed-off-by: Sean Christopherson<seanjc@google.com>

Yeah, I am not sure why it was "EPT_CAP_WT".  That one should have been 
for bit 12 (if it was useful at all).

Paolo
