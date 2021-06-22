Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5963B0A81
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 18:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231373AbhFVQmy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 12:42:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56681 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231260AbhFVQmw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Jun 2021 12:42:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624380036;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CroSby+8OZ67uh2dCf0EqW8w9Tx/xv7SGWPBn5OhZ6U=;
        b=AZXqNOqtPITz+Y3znoc/7N0tqaNyo73sk+yOCGNa4F2/xpYEruGc5p/H4j9nlqDTyk64Uz
        papVjqMgA3e7w5mv3Wv91KdMohPfSvVuFK61t7aqp3zW4wWrEX4F+lQzgWB5ePhDgpjXwi
        JVP14ibMZDeRPTREPEt3HYygVD4F2Ys=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-507-2n6OHn3yO7CIcGVNGvQLKA-1; Tue, 22 Jun 2021 12:40:34 -0400
X-MC-Unique: 2n6OHn3yO7CIcGVNGvQLKA-1
Received: by mail-wm1-f72.google.com with SMTP id w186-20020a1cdfc30000b02901ced88b501dso927032wmg.2
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 09:40:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CroSby+8OZ67uh2dCf0EqW8w9Tx/xv7SGWPBn5OhZ6U=;
        b=o2NEcb+PStzB5evp9NaIm2xoA7t79lcSgJAs0JeAGlcLX01rUNjOYUIl5m3dyT0ZUK
         e5lLjjXnpjEtMtAVtk6w3rYEQuA/aP2oXwXMu3bLA/nJGKCpRJFVQskjM3c/wydcewj1
         EIR1LvcKbxwM8FJL5r5pCKi43RrTvU70+IQqapMDm5jtWgYYuk3JXwUaU5PNh1u9VU87
         ASn89XS6/XM/pcN2NHGEmfXcKQUVbkwLNIOjACSjTq5FtMn28Rn5AK9zc9VauJT5C4iv
         7LI9oiMo5SPnuHnOHsvaT7tMcscUSSQD09fWnJkql8tdO0eXxtXoa11JlkDu4UpE5Yon
         36kw==
X-Gm-Message-State: AOAM5334ZNx7n6O6IN2yhHf1pwWfuX0M5cfvHiaPU89e9Nrg1lpyd8RD
        fVC71SoD2bDX64JydjsEPf9oldqZPpAR6sXuegY0o775xWDUddj2anGIoF25nWMgXohGRb8HMMe
        yNm+bK2LiVo0x
X-Received: by 2002:a5d:42c2:: with SMTP id t2mr6254165wrr.382.1624380033475;
        Tue, 22 Jun 2021 09:40:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxNuxHLD1MNbwu8SvdTS5Ils66PCYlE6o/X7QvwAknoCJFnMiWlRWusyqMXRZK3BVyli8h6Sg==
X-Received: by 2002:a5d:42c2:: with SMTP id t2mr6254146wrr.382.1624380033310;
        Tue, 22 Jun 2021 09:40:33 -0700 (PDT)
Received: from thuth.remote.csb (pd9575f2f.dip0.t-ipconnect.de. [217.87.95.47])
        by smtp.gmail.com with ESMTPSA id c18sm11328706wrt.83.2021.06.22.09.40.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jun 2021 09:40:32 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 3/4] lib/s390x: Fix the epsw inline
 assembly
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>
References: <20210622135517.234801-1-thuth@redhat.com>
 <20210622135517.234801-4-thuth@redhat.com> <20210622161240.03098bce@ibm-vm>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <61c28070-89a3-e694-988a-37db3873492f@redhat.com>
Date:   Tue, 22 Jun 2021 18:40:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210622161240.03098bce@ibm-vm>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/06/2021 16.12, Claudio Imbrenda wrote:
> On Tue, 22 Jun 2021 15:55:16 +0200
> Thomas Huth <thuth@redhat.com> wrote:
> 
>> According to the Principles of Operation, the epsw instruction
>> does not touch the second register if it is r0. With GCC we were
>> lucky so far that it never tried to use r0 here, but when compiling
>> the kvm-unit-tests with Clang, this indeed happens and leads to
>> very weird crashes. Thus let's make sure to never use r0 for the
>> second operand of the epsw instruction.
>>
>> Signed-off-by: Thomas Huth <thuth@redhat.com>
> 
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> 
> maybe also mention in the patch description why you changed + to =

Yes, that makes sense. I'll add something like:

While we're at it, also change the constraint modifier from "+" to "=" since 
these are only output parameters, not input.

  Thomas

