Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2DD0432553
	for <lists+kvm@lfdr.de>; Mon, 18 Oct 2021 19:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234171AbhJRRr5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 13:47:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25101 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232458AbhJRRry (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Oct 2021 13:47:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634579141;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n2ED4js5lS0lxq3Ati1A3TDBCk1NySWWfjAQp8swFKk=;
        b=Nlzhcpb7JsiClQTGG6+SKUkjkgM8vdD93nYdR3rYTImjLCmaDSjiFDoKDjdVlJ6SLPQG+4
        /wELIIlHP4ap/l8mWqWy3bXNC2/+kXxY+nPN6VELRdsZsbH+1p74ncgKeTUgZbxRAzFeyG
        Ez5lwp0VBAdX0WA3tlNOSeGqzPOnMq8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-347-Zk8_wrHSOKe1WirBXIpeyg-1; Mon, 18 Oct 2021 13:45:40 -0400
X-MC-Unique: Zk8_wrHSOKe1WirBXIpeyg-1
Received: by mail-wm1-f69.google.com with SMTP id n9-20020a1c7209000000b0030da7d466b8so269028wmc.5
        for <kvm@vger.kernel.org>; Mon, 18 Oct 2021 10:45:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=n2ED4js5lS0lxq3Ati1A3TDBCk1NySWWfjAQp8swFKk=;
        b=Z1co0jgb+go+an3DpSvk9l/7bp9aCKICQxpYzFpwEbt+JHydwywCXhHFRRphsnTbGl
         vcucP2kABur1joj9X0ylxgzGZ9C//Tx9PqEvrIutZuhhIOgds/aXKfirR3hztPrcZ7ZU
         c0HI1QsQqSgJ/rJIk/Wr/kx6PskS3TEjN1cmCwpItbwZNzbaUOyCGYffyI5AODNWpIl0
         ykOyzv1dQ2GZo9IfKgL2OmSrLMTMi4U/FcY68PUzkfdjZNmKVg2jAjYdIX6/WyQA9jZV
         krKDa/WlFaOMavhjSZv+qCSwabwCgAL5ej8XgB9+2JAMAFLhSadbpmRE164JBTZKOQlp
         v5PQ==
X-Gm-Message-State: AOAM531qX5iYPALZosGUzBuPi5eU8uCAMejhpw6FUC69+GCrTTURuRYS
        /YRWV26jtJfgtsmqrbW3BBQ6QYtBZUGALIQbaWwhHFp+opPtRzImNF4XyCZQrYUVnBWxozm/j5V
        S82XZM2PIaCut
X-Received: by 2002:adf:9bce:: with SMTP id e14mr37390908wrc.353.1634579138892;
        Mon, 18 Oct 2021 10:45:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwb3V17dtLU+oGhGUjA+36f3EHbAZynBn9/WOoQF719tD7ufpt4f37VqVGYlkWuNnsselkE1A==
X-Received: by 2002:adf:9bce:: with SMTP id e14mr37390885wrc.353.1634579138691;
        Mon, 18 Oct 2021 10:45:38 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id q12sm9473183wrp.13.2021.10.18.10.45.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Oct 2021 10:45:38 -0700 (PDT)
Message-ID: <e9af2f2e-a0cf-1916-c960-2a663e6f4596@redhat.com>
Date:   Mon, 18 Oct 2021 19:45:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v3 2/2] x86: sgx_vepc: implement SGX_IOC_VEPC_REMOVE ioctl
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        dave.hansen@linux.intel.com, x86@kernel.org, yang.zhong@intel.com,
        jarkko@kernel.org, bp@suse.de
References: <20211016071434.167591-1-pbonzini@redhat.com>
 <20211016071434.167591-3-pbonzini@redhat.com> <YW2sKq1pXkuiG1rb@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YW2sKq1pXkuiG1rb@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/10/21 19:17, Sean Christopherson wrote:
> 			/*
> 			 * Report errors due to #GP or SGX_ENCLAVE_ACT, but do
> 			 * not WARN as userspace can induce said failures by
> 			 * calling the ioctl concurrently on multiple vEPCs or
> 			 * while one or more CPUs is running the enclave.  Only
> 			 * a #PF on EREMOVE indicates a kernel/hardware issue.
> 			 */
> 			WARN_ON_ONCE(encls_faulted(ret) &&
> 				     ENCLS_TRAPNR(ret) == X86_TRAP_PF);

or != X86_TRAP_GP, just to avoid having a v5? :)

Paolo

