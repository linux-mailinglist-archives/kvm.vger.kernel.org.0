Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39CFA7C495E
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 07:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbjJKFqM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 01:46:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbjJKFqK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 01:46:10 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE1D19B;
        Tue, 10 Oct 2023 22:46:02 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d2e1a72fcca58-6969b391791so4562151b3a.3;
        Tue, 10 Oct 2023 22:46:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697003162; x=1697607962; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xf/p4DjELpfr1NcB6qfw3yuqnU4IRTf9hEu7aSbTs6Q=;
        b=LcwPDc4INGTReXION7HXcKqIr9efsf6zWJa8iyKcajeqXuj+9c7S/g9Gm3wu7u/r0k
         93ApCbUIW032kYC7lQWFzlKET+mN97fByIL7xEBpLKmKnpTDqnRlsu+bWUNNl4/NlsvQ
         u0m4GdEjbcbf4Fmq7W+pVosrapYrmgGaXUg+YRoL93ONG5ihfI6YKYqSWnMGBr1OExau
         scYHQvgnNKR/oVk2J9IvPs/CYq7wmLHjkl+Jas4MyUFQU+roqafHAnOnRx3NAhdWdiEw
         MWPDePMhDlSpKO/5Yo7UP6fnnn+Izd3qKxcKmICKVAC1VIsOc48S/1JkFcKUgAg68EaT
         fB4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697003162; x=1697607962;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xf/p4DjELpfr1NcB6qfw3yuqnU4IRTf9hEu7aSbTs6Q=;
        b=uu/+HiVilCK2tmIoHCVEdqTVqa+iX8kD6Ts4C0mSmJlW79B27YOUPte6uYYzpKk/4m
         ZeNBDWodidZyVqKpJ0HNt5+OWejhlWUCID7InRtNZmMePBpa4ihudeex19RzMDVBum5N
         cI+eVIEtV6c5Dl9yBp7AxLlDuMJ7L3OgDTJ3dqMkoo/fTXy7QFHENp7Z501kv1e7Bmsc
         pJAovt935tmqCjmxKcptgc+uDCEmhfrbHnSaakPoA6iA8n3iO6J1QLbKr3jejjcbSxIO
         GRBmvpUnJ0aRescYMwWkJpU1M1W6oZrCjseDyJshftMkVqEvWd9Q7BTPQwaJT6iGpPfV
         N8tg==
X-Gm-Message-State: AOJu0Yw8pWWffGmw227sbSq2OU3rtidItVrJXdTnFYYSP9meGjV9ehvc
        wbaYavtKETwzfT8BjRK66T4=
X-Google-Smtp-Source: AGHT+IHQslnR6hlgXl6oZqRY7WGzCXPOGRjmQDAzmyoHPA79ASonPxlA3FgFcb5JYk9FUU3nt7kS9Q==
X-Received: by 2002:a05:6a20:244e:b0:16b:e46e:1269 with SMTP id t14-20020a056a20244e00b0016be46e1269mr11501132pzc.30.1697003162278;
        Tue, 10 Oct 2023 22:46:02 -0700 (PDT)
Received: from [192.168.0.106] ([103.131.18.64])
        by smtp.gmail.com with ESMTPSA id jh13-20020a170903328d00b001bba7aab822sm12980766plb.5.2023.10.10.22.45.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Oct 2023 22:46:01 -0700 (PDT)
Message-ID: <a080c284-e9e3-452a-9ce2-56c93ef04c02@gmail.com>
Date:   Wed, 11 Oct 2023 12:45:55 +0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 1/1] vfio/nvgpu: Add vfio pci variant module for grace
 hopper
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     ankita@nvidia.com, jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        aniketa@nvidia.com, cjia@nvidia.com, kwankhede@nvidia.com,
        targupta@nvidia.com, vsethi@nvidia.com, acurrid@nvidia.com,
        apopple@nvidia.com, jhubbard@nvidia.com, danw@nvidia.com,
        anuaggarwal@nvidia.com, dnigam@nvidia.com, udhoke@nvidia.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20231007202254.30385-1-ankita@nvidia.com>
 <ZSHykZ2GgSn0fE_x@debian.me>
 <20231009133612.3fdd86a9.alex.williamson@redhat.com>
Content-Language: en-US
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <20231009133612.3fdd86a9.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/10/2023 02:36, Alex Williamson wrote:
> On Sun, 8 Oct 2023 07:06:41 +0700
> Bagas Sanjaya <bagasdotme@gmail.com> wrote:
> 
>> On Sun, Oct 08, 2023 at 01:52:54AM +0530, ankita@nvidia.com wrote:
>>> PCI BAR are aligned to the power-of-2, but the actual memory on the
>>> device may not. A read or write access to the physical address from the
>>> last device PFN up to the next power-of-2 aligned physical address
>>> results in reading ~0 and dropped writes.
>>>   
>>
>> Reading garbage or padding in that case?
>>
>> Confused...
> 
> The coherent memory size is rounded to a power-of-2 to be compliant with
> PCI BAR semantics, but reading beyond the implemented size fills the
> return buffer with -1 data, as is common on many platforms when reading
> from an unimplemented section of the address space.  Thanks,
> 
> Alex
> 

Thanks for the explanation!

-- 
An old man doll... just what I always wanted! - Clara

