Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 153FF38B01F
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 15:36:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233191AbhETNiR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 09:38:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32173 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231733AbhETNiP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 May 2021 09:38:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621517811;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jDqb0WbNRWfVzDXzZndrXkYjxKSiX/oojU5U/u7mGHY=;
        b=AhxtC2M0X0MRhSV5BheAnqpBa23Ql1S+kg3g5zCw+LJ+Zg1B0huQcB+vwpMQroGzUxdfIl
        RStBJSV33OuWsTYdIG/4YrmFrTDHeITT8qdifdqGNAOcUd7fTEvkihHpj/Zs0pB+FR3w+P
        q1WFkQfVcIB93PG0cVFRlNyyYVQfcr4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-397-xDykYFsDMZy_qaEl3SY-jw-1; Thu, 20 May 2021 09:36:50 -0400
X-MC-Unique: xDykYFsDMZy_qaEl3SY-jw-1
Received: by mail-wr1-f72.google.com with SMTP id 1-20020adf93810000b029010fd5ac4ed7so8643291wrp.15
        for <kvm@vger.kernel.org>; Thu, 20 May 2021 06:36:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=jDqb0WbNRWfVzDXzZndrXkYjxKSiX/oojU5U/u7mGHY=;
        b=KqN9SOk5CPItqChxpDtbxL28P4KIH6r1aibiAQ20jLk3ubJxqg3F8NXMNjd0wOEG5V
         Ve+E/G1GAxJOhnjmQRFLi3aB1AaS3tWFt7raCCvyfjV9pE3VfFnPnJRYf/Dx8AVzAQdB
         C+PZ0TzeFdSmaCq8OTicmB4WI85CaPFkRXcZFLce5YN4+GYtlAs7jQfKNAm4ru2T5wiz
         9qjKkeF5mW8DyQKspWmN1/c0urDdAcLDsFw/zwILZ7YgQlUS8x7TohHZeQ3TfR9D1yn0
         uk73xaT4oLgFbz2q8pmygJueDHkLqk3yy8NK8nCH3l3UcjG5pdG0sWnOcfVD6UiBTzEd
         TUDw==
X-Gm-Message-State: AOAM531Tc5b5MMyUOTUTgNVcHhchnhzr6qRAwZrskksQmm2Qw2pxFVtG
        JQpwrZi55wExd44VF/iwiM/Zt9pmiDy7YXVAnGj9HrwNwFXTHRmc+I55WfgcxTf7DNB98oZLVY0
        xugIF57FRM1Yg
X-Received: by 2002:a5d:500b:: with SMTP id e11mr4383043wrt.209.1621517809072;
        Thu, 20 May 2021 06:36:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxaorDOozd3/iekfxe00tdpJtoWykCK/Q6hRKJwhMQfLXUiMcAmy0IfmqDRNBhc87uSKFjmXg==
X-Received: by 2002:a5d:500b:: with SMTP id e11mr4383010wrt.209.1621517808685;
        Thu, 20 May 2021 06:36:48 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c6315.dip0.t-ipconnect.de. [91.12.99.21])
        by smtp.gmail.com with ESMTPSA id y20sm9770638wmi.0.2021.05.20.06.36.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 May 2021 06:36:48 -0700 (PDT)
Subject: Re: [kvm-unit-tests RFC 0/2] s390x: Add snippet support
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com, cohuck@redhat.com
References: <20210520094730.55759-1-frankja@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <7c17d790-5a3c-d4ea-8d78-7148dbc6ca60@redhat.com>
Date:   Thu, 20 May 2021 15:36:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210520094730.55759-1-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20.05.21 11:47, Janosch Frank wrote:
> The SIE support allows us to run guests and test the hypervisor's
> (V)SIE implementation. However it requires that the guest instructions
> are binary which limits the complexity of the guest code.
> 
> The snippet support provides a way to write guest code as ASM or C and
> simply memcpy it into guest memory. Some of the KVM-unit-test library
> can be re-used which further speeds up guest code development.
> 
> The included mvpg-sie test helped us to deliver the KVM mvpg fixes
> which Claudio posted a short while ago. In the future I'll post Secure
> Execution snippet support patches which was my initial goal with this
> series anyway.
> 
> I heard you liked tests so I put tests inside tests so you can test
> while you test.

The idea sounds sane to me.

-- 
Thanks,

David / dhildenb

