Return-Path: <kvm+bounces-1491-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E80D7E7D65
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 16:25:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9561FB20F73
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 15:25:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A55A1D547;
	Fri, 10 Nov 2023 15:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RfNAI5jg"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F6381C697
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 15:25:18 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 305363A880
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 07:25:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699629916;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ykvHSfMbjpS4GhZVz1XstEIoiqCty8u1PZ0bJZYWpdA=;
	b=RfNAI5jgw7jSkK0J0ghqWXX0tpExXLqQIqityTAzMAOIuse+V37PFa1wfh/9y85T+d6/1H
	c2YR0tpJ8UecGzm7c9LfpsNkwAjavwcD5K5vrCsK327fnWnhqacSAf6lBsHewv23A7/T5Q
	H5tPMwczxts80XpQGvBxGWRxz2VdKPM=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-517-ZeP51kAVME-4f6Z1lh0CPg-1; Fri, 10 Nov 2023 10:25:12 -0500
X-MC-Unique: ZeP51kAVME-4f6Z1lh0CPg-1
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-77892a3d8f3so235737685a.3
        for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 07:25:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699629912; x=1700234712;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ykvHSfMbjpS4GhZVz1XstEIoiqCty8u1PZ0bJZYWpdA=;
        b=sFn8c8esrxjZOlG/Tj+hIxbM/X2S2w4kYLUJdKNqxwS4tlhHjgOWnn4fnL9Gv4pnmO
         HaV7jx+uvAkjE2cNJ6D/z6GbPX5LI5OHlXnyPNjK5rNvmP/KbTpnEOhbKuzsL/+b0IrG
         //CcqVqZcbcyIf63ZIO7hxDRGCGJcmxP3e3PKwHUdwuI1QJMD+JQUdtDTxMZOtIMioBA
         SZqvaOFp4op1LNTazX7k0zZWHWycnIHqJqOVohjgL8dSjr82EONdcH7kOWvAYKPxF/I2
         bjyEgZJjvF3yHo42kJ/Xkkgml62GAs+IOPD825DvSHdSunYRZBRNIf2ElCkuLKbAlJii
         QrOg==
X-Gm-Message-State: AOJu0YzHhjSfPy1yVdxlWXJwXI//zEaY/HTmWruozhlgPMEy4L9W+HdL
	2w2kolijI6KyTgXc7gyyiHvMiYxUTD/hBGKn2Q1keHSjiDb/jMowYmAGt0duODmvw6Cj+cRIVe4
	Cz2l0p39ku9aH/nJuaOiM
X-Received: by 2002:a05:620a:3908:b0:77a:1c6c:7924 with SMTP id qr8-20020a05620a390800b0077a1c6c7924mr9619648qkn.60.1699629911838;
        Fri, 10 Nov 2023 07:25:11 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFbViORS6nLPU41NeEkuJbQsen7LBobPW/WKI7s9gHKSRMex2w6ggJSxHS5uq6c9PtqmGtgzQ==
X-Received: by 2002:a05:620a:3908:b0:77a:1c6c:7924 with SMTP id qr8-20020a05620a390800b0077a1c6c7924mr9619628qkn.60.1699629911601;
        Fri, 10 Nov 2023 07:25:11 -0800 (PST)
Received: from [192.168.0.6] (ip-109-43-177-79.web.vodafone.de. [109.43.177.79])
        by smtp.gmail.com with ESMTPSA id e7-20020a05620a12c700b007676f3859fasm758403qkl.30.2023.11.10.07.25.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Nov 2023 07:25:11 -0800 (PST)
Message-ID: <ff7a7cd0-430c-4cfe-a392-c1a5b212d5ed@redhat.com>
Date: Fri, 10 Nov 2023 16:25:06 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests GIT PULL 00/26] s390x: multiline unittests.cfg,
 sclp enhancements, topology fixes and improvements, sie without MSO/MSL, 2G
 guest alignment, bug fixes
Content-Language: en-US
To: Nico Boehr <nrb@linux.ibm.com>, pbonzini@redhat.com,
 andrew.jones@linux.dev
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com
References: <20231110135348.245156-1-nrb@linux.ibm.com>
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20231110135348.245156-1-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/11/2023 14.52, Nico Boehr wrote:
> Hi Paolo and/or Thomas,
> 
> lots of code for s390x has accumulated, so it's time for another PR :)
> 
> Please note that this PR includes a common code change from Nina (see below).
> 
> Changes in this pull request:
> 
> * Nina contributed multiline support for unittests.cfg in common code,
> * Janosch contributed enhancements for the sclp console,
> * Nina fixed some issues in the topology tests and improved coverage,
> * I've added support for running sie() tests without MSO/MSL,
> * kvm-unit-tests is now compatible with environments which require 2GB alignment
>    of guests in SIE,
> * several smaller improvements and bug fixes.
> 
> Thanks
> Nico
> 
> MERGE: https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/merge_requests/48

Thanks, merged now!

  Thomas



