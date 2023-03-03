Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6159C6A927B
	for <lists+kvm@lfdr.de>; Fri,  3 Mar 2023 09:33:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbjCCIde (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Mar 2023 03:33:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbjCCIdd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Mar 2023 03:33:33 -0500
Received: from mail-oa1-x35.google.com (mail-oa1-x35.google.com [IPv6:2001:4860:4864:20::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CE2F2D4C
        for <kvm@vger.kernel.org>; Fri,  3 Mar 2023 00:33:26 -0800 (PST)
Received: by mail-oa1-x35.google.com with SMTP id 586e51a60fabf-172afa7bee2so2184941fac.6
        for <kvm@vger.kernel.org>; Fri, 03 Mar 2023 00:33:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1677832405;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5poiB9hHsOof3PcUw2itX1s4KSe9/ZAMgLRbkPBocmw=;
        b=FbWXFoPPCV2woaEFtMpP8EV9lfsqYjE40+w4F0JcHNkyd0MJuJ6EUuEOgBEQA1PceL
         MJdWRXjEsRaDpgpi8u9GxIdWJjGO3+tjQJAGR9xo0wE4n/72MD6s8caj291SKJtPb2VD
         Lt+sdzK58zf4LXGUtQtjQrPFMYZYp7SowvzVmVN+rfJu4LyVf6KnLIZhBZVlqXK49MOC
         IFiz6dQqt50J6W+y05GXsb0PxlVf44UrtH/QH+i0HscaFdFTddTOhMBebe0gDOMLAMCx
         5xZS/KbOJI9rVUtQLXEMt/r7VNLkj5FAx91/mlFkQbmxIEmoYbBgQcHwnEPl/zybcjVT
         dJ0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677832405;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5poiB9hHsOof3PcUw2itX1s4KSe9/ZAMgLRbkPBocmw=;
        b=YsLACeSU/WT62oXGogBYGgp/bXLeekWz3wmscsGCBcqL2mpJ9G8Pl2xOJ2e50wqdKQ
         f/+uldJJPyawhKKiPv19BIXfD+tDDT/wtjWkpD1+dLFdtbcpgbi7OV1DWIqq/4/s9HJp
         bZ4al+U9SNqS/NBRzulbgrvfbgTBIPf3hBdZj11eUAeRneEuql5///vkgU5L3443F4ly
         NAJLkiV3IQchRZn73c88qzYILzG9dRoICtJsVUdAqloQpSl5oWdEf4ynO20DWbvG9ZP4
         lw9JMIJqRM8EXxIMHyaSV0QaNPHoTjU1NgcvLZviz//+veVJAtl+OiAb4ggJSYZsrMq+
         4OGA==
X-Gm-Message-State: AO0yUKWRoc1wsJfrnDgI871WlrAaQKdi4v4HbirrcFOYWGywwk08j2fY
        +mbAe65oNMzlg9HH/vMi3MXcUw==
X-Google-Smtp-Source: AK7set8hlr1yHx+OBqCBQiyW/tJc0LeKAGcAzKgQug0uqmMG1EmbLpBoo1gFuxZYTLA7H9cb7XHBMA==
X-Received: by 2002:a05:6871:207:b0:172:7c37:69b with SMTP id t7-20020a056871020700b001727c37069bmr712055oad.5.1677832404958;
        Fri, 03 Mar 2023 00:33:24 -0800 (PST)
Received: from [192.168.68.107] ([177.189.53.31])
        by smtp.gmail.com with ESMTPSA id eg27-20020a056870989b00b001727d67f2dbsm746714oab.40.2023.03.03.00.33.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Mar 2023 00:33:24 -0800 (PST)
Message-ID: <a6b263e9-cc54-e657-8dbb-0c08f5864fe9@ventanamicro.com>
Date:   Fri, 3 Mar 2023 05:33:10 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v4 04/26] gdbstub: clean-up indent on gdb_exit
Content-Language: en-US
To:     =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        qemu-devel@nongnu.org
Cc:     Weiwei Li <liweiwei@iscas.ac.cn>,
        =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Laurent Vivier <laurent@vivier.eu>,
        nicolas.eder@lauterbach.com, Ilya Leoshkevich <iii@linux.ibm.com>,
        kvm@vger.kernel.org,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        qemu-s390x@nongnu.org, Stafford Horne <shorne@gmail.com>,
        Bin Meng <bin.meng@windriver.com>, Marek Vasut <marex@denx.de>,
        Greg Kurz <groug@kaod.org>, Song Gao <gaosong@loongson.cn>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        Chris Wulff <crwulff@gmail.com>, qemu-riscv@nongnu.org,
        Michael Rolnik <mrolnik@gmail.com>, qemu-arm@nongnu.org,
        Cleber Rosa <crosa@redhat.com>,
        Artyom Tarasenko <atar4qemu@gmail.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Alexandre Iooss <erdnaxe@crans.org>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        mads@ynddal.dk, Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        qemu-ppc@nongnu.org,
        Richard Henderson <richard.henderson@linaro.org>,
        John Snow <jsnow@redhat.com>,
        Xiaojuan Yang <yangxiaojuan@loongson.cn>,
        Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Mahmoud Mandour <ma.mandourr@gmail.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Bastian Koppelmann <kbastian@mail.uni-paderborn.de>,
        Yanan Wang <wangyanan55@huawei.com>,
        David Hildenbrand <david@redhat.com>,
        Taylor Simpson <tsimpson@quicinc.com>,
        Peter Maydell <peter.maydell@linaro.org>
References: <20230302190846.2593720-1-alex.bennee@linaro.org>
 <20230302190846.2593720-5-alex.bennee@linaro.org>
From:   Daniel Henrique Barboza <dbarboza@ventanamicro.com>
In-Reply-To: <20230302190846.2593720-5-alex.bennee@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/2/23 16:08, Alex Bennée wrote:
> Otherwise checkpatch will throw a hissy fit on the later patches that
> split this function up.
> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> ---

Reviewed-by: Daniel Henrique Barboza <dbarboza@ventanamicro.com>

>   gdbstub/gdbstub.c | 28 ++++++++++++++--------------
>   1 file changed, 14 insertions(+), 14 deletions(-)
> 
> diff --git a/gdbstub/gdbstub.c b/gdbstub/gdbstub.c
> index fb9c49e0fd..63b56f0027 100644
> --- a/gdbstub/gdbstub.c
> +++ b/gdbstub/gdbstub.c
> @@ -3021,27 +3021,27 @@ static void gdb_read_byte(uint8_t ch)
>   /* Tell the remote gdb that the process has exited.  */
>   void gdb_exit(int code)
>   {
> -  char buf[4];
> +    char buf[4];
>   
> -  if (!gdbserver_state.init) {
> -      return;
> -  }
> +    if (!gdbserver_state.init) {
> +        return;
> +    }
>   #ifdef CONFIG_USER_ONLY
> -  if (gdbserver_state.socket_path) {
> -      unlink(gdbserver_state.socket_path);
> -  }
> -  if (gdbserver_state.fd < 0) {
> -      return;
> -  }
> +    if (gdbserver_state.socket_path) {
> +        unlink(gdbserver_state.socket_path);
> +    }
> +    if (gdbserver_state.fd < 0) {
> +        return;
> +    }
>   #endif
>   
> -  trace_gdbstub_op_exiting((uint8_t)code);
> +    trace_gdbstub_op_exiting((uint8_t)code);
>   
> -  snprintf(buf, sizeof(buf), "W%02x", (uint8_t)code);
> -  put_packet(buf);
> +    snprintf(buf, sizeof(buf), "W%02x", (uint8_t)code);
> +    put_packet(buf);
>   
>   #ifndef CONFIG_USER_ONLY
> -  qemu_chr_fe_deinit(&gdbserver_state.chr, true);
> +    qemu_chr_fe_deinit(&gdbserver_state.chr, true);
>   #endif
>   }
>   
