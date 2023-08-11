Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34604779592
	for <lists+kvm@lfdr.de>; Fri, 11 Aug 2023 19:04:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbjHKREM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Aug 2023 13:04:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbjHKREL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Aug 2023 13:04:11 -0400
Received: from newman.cs.utexas.edu (newman.cs.utexas.edu [128.83.139.110])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFDE519F
        for <kvm@vger.kernel.org>; Fri, 11 Aug 2023 10:04:10 -0700 (PDT)
X-AuthUser: ysohail
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=cs.utexas.edu;
        s=default; t=1691773449;
        bh=xu/gyq+eDqppIBVZ8YjPTKpAbmHcrg8A29yhyhB+CoM=;
        h=Date:To:From:Subject:From;
        b=P++hLWj5Yfe3sjmFRqwD6DihTGB2UndldZJfBJwVvV9xpN3+mi9cgwfJQTFnvGagz
         iGE2LKk4A99NH/Ej+32dozcJL6Cxe3tQF36UCgSOYN1p58DnsUxP0nk1ylQ0XmU5nG
         xX2jiUi6VNE+ZnsW7AD38JR2BQcALL/70uPdEsvs=
Received: from [192.168.0.202] (71-138-92-128.lightspeed.hstntx.sbcglobal.net [71.138.92.128])
        (authenticated bits=0)
        by newman.cs.utexas.edu (8.14.4/8.14.4/Debian-4.1ubuntu1.1) with ESMTP id 37BH498V045807
        (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 11 Aug 2023 12:04:09 -0500
Message-ID: <12a72fb7-4125-c705-6dd6-733ec23de80e@cs.utexas.edu>
Date:   Fri, 11 Aug 2023 12:04:08 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To:     kvm@vger.kernel.org
From:   Yahya Sohail <ysohail@cs.utexas.edu>
Subject: VM Memory Map
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.3.9 (newman.cs.utexas.edu [128.83.139.110]); Fri, 11 Aug 2023 12:04:09 -0500 (CDT)
X-Virus-Scanned: clamav-milter 0.103.8 at newman
X-Virus-Status: Clean
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

Accesses to certain memory addresses by the guest trigger a 
KVM_EXIT_MMIO. I can't seem to find a memory map in the documentation or 
source that describes exactly which addresses are real memory and which 
addresses are MMIO addresses (on x86, if that matters). Is there any 
such documentation or a listing in the source?

Is there any way to configure which addresses are MMIO? I hoped that 
mapping memory to MMIO address regions with the 
KVM_SET_USER_MEMORY_REGION ioctl would allow me to use them as memory, 
but that didn't work. The only ioctls that seem relevant to MMIO are 
KVM_(UN)REGISTER_COALESCED_MMIO, but those only allow coalescing MMIO 
exits, not changing which addresses cause them.

Thanks,
Yahya Sohail
