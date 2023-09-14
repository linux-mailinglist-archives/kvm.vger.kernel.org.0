Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8D0679FD53
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 09:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234521AbjINHi5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 03:38:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232903AbjINHi4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 03:38:56 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A40C2F3
        for <kvm@vger.kernel.org>; Thu, 14 Sep 2023 00:38:51 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id 2adb3069b0e04-501bd6f7d11so1007415e87.1
        for <kvm@vger.kernel.org>; Thu, 14 Sep 2023 00:38:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694677130; x=1695281930; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6a07noXEEeKYvWLKsxvl2WHpK5F69z9OVfpm+Ch6jm4=;
        b=wfvhypVjBSmlhVV6u3v8M2MzBytf9+iIm6KzBcB6elUdF3DTDH94hSKv/tTFIVqAfj
         cfdtF0gnrUATo4+059IcsnWIXoPBq6kvAiUeaEDn1ZYDjZ03RR97vBAWOR3NfvPXYNAt
         jQRdJDWrgyCRwnZ7fsJ4xOQRezvkHUTdMVl1G13hS3IAoUt7/AdRituD1IClQzyElvx4
         MokSXiXaYPUIw188Mxt72SpAiHCKqE8nWpIhDtzhdV1DiZ07TvXXT79wI402jBPf2GY3
         ecvVMpB5b9fqJ1TNGOsOECuQgxEZ/UsBVOdPBrlg5fhmT2ufiGSQ8soOa3qyWgJpQXEy
         0hGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694677130; x=1695281930;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6a07noXEEeKYvWLKsxvl2WHpK5F69z9OVfpm+Ch6jm4=;
        b=p016yCK94c3G26zKNJpBskyWiZXOAwWDh6Na6uNY8uc8v4gr9mKM6M/ONGWMqQOxkm
         VWqKmmUu43fbOELWTj3oWLYO0iJQuku+nEGQ3OMv+1lRrVqqvMZyXeId447ZjUvqF+Ak
         B8btYMdwrcFJclJfcuyPLDbdnvukdmNB8UTPwrkYxZvGUYYbK6LdTHQVKZB/XR1cnVYl
         tc791m8rNy0u3yAO35PFxpyT/n0wlMMIkCXzVlgDZsr8JAzU00hiCl9sRqT/YxfOhEvm
         0NjR1JSME+oYsYAwUFoh4HRaiT9oTl8ZNoEYsfnMze0FKeOxHtykoe5Lt14C0J/mtfDW
         bZ4g==
X-Gm-Message-State: AOJu0YyrzefiJutpf6/c0Q9AG23Hmc5Se5wzqBSxUrM5oRnnNMplsW+a
        KZ2fqI3pwonqr1IjOSDv/vXncw==
X-Google-Smtp-Source: AGHT+IFvOeScxfD7nNArBjxb2/X37ctH0HekJVyd4OoEGRMHHoGJiVsOHKisFnZfoY6lhnmvKpBVdQ==
X-Received: by 2002:a05:6512:3b95:b0:500:8ecb:509 with SMTP id g21-20020a0565123b9500b005008ecb0509mr4434920lfv.15.1694677129826;
        Thu, 14 Sep 2023 00:38:49 -0700 (PDT)
Received: from [192.168.69.115] (sem44-h01-176-172-56-29.dsl.sta.abo.bbox.fr. [176.172.56.29])
        by smtp.gmail.com with ESMTPSA id k17-20020aa7c391000000b00521f4ee396fsm556332edq.12.2023.09.14.00.38.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Sep 2023 00:38:49 -0700 (PDT)
Message-ID: <b98d2eb3-7228-5a78-3c91-d347f160bc8a@linaro.org>
Date:   Thu, 14 Sep 2023 09:38:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [PATCH v4 10/21] i386: Introduce module-level cpu topology to
 CPUX86State
Content-Language: en-US
To:     Zhao Liu <zhao1.liu@linux.intel.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Zhenyu Wang <zhenyu.z.wang@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Babu Moger <babu.moger@amd.com>,
        Zhao Liu <zhao1.liu@intel.com>,
        Zhuocheng Ding <zhuocheng.ding@intel.com>
References: <20230914072159.1177582-1-zhao1.liu@linux.intel.com>
 <20230914072159.1177582-11-zhao1.liu@linux.intel.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20230914072159.1177582-11-zhao1.liu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/9/23 09:21, Zhao Liu wrote:
> From: Zhuocheng Ding <zhuocheng.ding@intel.com>
> 
> smp command has the "clusters" parameter but x86 hasn't supported that
> level. "cluster" is a CPU topology level concept above cores, in which
> the cores may share some resources (L2 cache or some others like L3
> cache tags, depending on the Archs) [1][2]. For x86, the resource shared
> by cores at the cluster level is mainly the L2 cache.
> 
> However, using cluster to define x86's L2 cache topology will cause the
> compatibility problem:
> 
> Currently, x86 defaults that the L2 cache is shared in one core, which
> actually implies a default setting "cores per L2 cache is 1" and
> therefore implicitly defaults to having as many L2 caches as cores.
> 
> For example (i386 PC machine):
> -smp 16,sockets=2,dies=2,cores=2,threads=2,maxcpus=16 (*)
> 
> Considering the topology of the L2 cache, this (*) implicitly means "1
> core per L2 cache" and "2 L2 caches per die".
> 
> If we use cluster to configure L2 cache topology with the new default
> setting "clusters per L2 cache is 1", the above semantics will change
> to "2 cores per cluster" and "1 cluster per L2 cache", that is, "2
> cores per L2 cache".
> 
> So the same command (*) will cause changes in the L2 cache topology,
> further affecting the performance of the virtual machine.
> 
> Therefore, x86 should only treat cluster as a cpu topology level and
> avoid using it to change L2 cache by default for compatibility.
> 
> "cluster" in smp is the CPU topology level which is between "core" and
> die.
> 
> For x86, the "cluster" in smp is corresponding to the module level [2],
> which is above the core level. So use the "module" other than "cluster"
> in i386 code.
> 
> And please note that x86 already has a cpu topology level also named
> "cluster" [3], this level is at the upper level of the package. Here,
> the cluster in x86 cpu topology is completely different from the
> "clusters" as the smp parameter. After the module level is introduced,
> the cluster as the smp parameter will actually refer to the module level
> of x86.
> 
> [1]: 864c3b5c32f0 ("hw/core/machine: Introduce CPU cluster topology support")
> [2]: Yanan's comment about "cluster",
>       https://lists.gnu.org/archive/html/qemu-devel/2023-02/msg04051.html
> [3]: SDM, vol.3, ch.9, 9.9.1 Hierarchical Mapping of Shared Resources.
> 
> Signed-off-by: Zhuocheng Ding <zhuocheng.ding@intel.com>
> Co-developed-by: Zhao Liu <zhao1.liu@intel.com>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> ---
> Changes since v1:
>   * The background of the introduction of the "cluster" parameter and its
>     exact meaning were revised according to Yanan's explanation. (Yanan)
> ---
>   hw/i386/x86.c     | 1 +
>   target/i386/cpu.c | 1 +
>   target/i386/cpu.h | 5 +++++
>   3 files changed, 7 insertions(+)


> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index 470257b92240..556e80f29764 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -1903,6 +1903,11 @@ typedef struct CPUArchState {
>   
>       /* Number of dies within this CPU package. */
>       unsigned nr_dies;
> +    /*
> +     * Number of modules within this CPU package.
> +     * Module level in x86 cpu topology is corresponding to smp.clusters.
> +     */
> +    unsigned nr_modules;
>   } CPUX86State;

It would be really useful to have an ASCII art comment showing
the architecture topology. Also for clarity the topo fields from
CPU[Arch]State could be moved into a 'topo' sub structure, or even
clearer would be to re-use the X86CPUTopoIDs structure?
