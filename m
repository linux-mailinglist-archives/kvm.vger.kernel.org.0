Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA563BFA8
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2019 01:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390508AbfFJXAZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jun 2019 19:00:25 -0400
Received: from ahs5.r4l.com ([158.69.52.156]:55852 "EHLO ahs5.r4l.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390340AbfFJXAY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jun 2019 19:00:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=extremeground.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=JlrcWl1eK+Q+zlhb6QH4rHkppolRedg6FPwBpwo9jkM=; b=t/Eq574KAU18MSvNwjIqy4nLkI
        82XGQkRO0vZvdb60QtQ62QbfkhW6ezVPBzLRjMtstc79SRX1gbpTsfBYyHcc7JY/fVBk+Zumy6Vxt
        BpgdQC+tdqYrjKajr14kojAO8pmTRH9ufV1/lxfgcz5eols2ifdjtJTzBAjYqQJjrWOGvD4TwO/gf
        zWUqhCACFOL0NV0SfpcCmuvzyyj8qfanJp3o2STF6kZlJfFjSRyktvXvgVWVtIJeg64sdfIq1vxsv
        RjZ+CE7Cs51+TvKC47ZKWi/F94//TpAt+Bd8zDf/ibQfJVuK16eyGAoBwJr/6i8kc9Q6GyW/CTnCB
        vgpEfwvQ==;
Received: from cpeac202ed5e073-cmac202ed5e070.cpe.net.cable.rogers.com ([99.237.87.227]:36588 helo=[192.168.1.20])
        by ahs5.r4l.com with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.92)
        (envelope-from <gary@extremeground.com>)
        id 1haTH4-0003Mk-BV; Mon, 10 Jun 2019 19:00:22 -0400
Subject: Re: [Qemu-devel] kvm / virsh snapshot management
To:     Eric Blake <eblake@redhat.com>,
        Stefan Hajnoczi <stefanha@gmail.com>
Cc:     Kevin Wolf <kwolf@redhat.com>, John Snow <jsnow@redhat.com>,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <abb7990e-0331-67a4-af92-05276366478c@extremeground.com>
 <20190610121941.GI14257@stefanha-x1.localdomain>
 <dc7a70ea-c94f-e975-df44-b0199da698e2@extremeground.com>
 <ab3e81c2-f0ce-2ef5-bbe7-948a87463b59@extremeground.com>
 <edf57b3a-660c-0964-2455-9461b9aa2711@redhat.com>
From:   Gary Dale <gary@extremeground.com>
Message-ID: <33b31422-1198-783a-cb15-8687a3f30199@extremeground.com>
Date:   Mon, 10 Jun 2019 19:00:21 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <edf57b3a-660c-0964-2455-9461b9aa2711@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-CA
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - ahs5.r4l.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - extremeground.com
X-Get-Message-Sender-Via: ahs5.r4l.com: authenticated_id: gary@extremeground.com
X-Authenticated-Sender: ahs5.r4l.com: gary@extremeground.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2019-06-10 6:07 p.m., Eric Blake wrote:
> On 6/10/19 4:27 PM, Gary Dale wrote:
>
>> Trying this against a test VM, I ran into a roadblock. My command line
>> and the results are:
>>
>> # virsh blockcommit stretch "/home/secure/virtual/stretch.qcow2" --top
>> stretchS3 --delete --wait
>> error: unsupported flags (0x2) in function qemuDomainBlockCommit
>>
>> I get the same thing when the path to the qcow2 file isn't quoted.
> That's a libvirt limitation - the --delete flag is documented from the
> generic API standpoint, but not (yet) implemented for the qemu driver
> within libvirt. For now, you have to omit --delete from your virsh
> command line, and then manually 'rm' the unused external file after the
> fact.
Which is not possible since I'm using internal snapshots.
>
>> I noted in
>> https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/virtualization_administration_guide/sub-sect-domain_commands-using_blockcommit_to_shorten_a_backing_chain
>> that the options use a single "-".
> Sounds like a bug in that documentation.

Yes, and the man page also seems to be wrong. The section on blockcommit 
begins:

blockcommit domain path [bandwidth] [--bytes] [base] [--shallow] [top] 
[--delete]
        [--keep-relative] [--wait [--async] [--verbose]] [--timeout 
seconds] [--active]
        [{--pivot | --keep-overlay}]
            Reduce the length of a backing image chain, by committing 
changes at the top of the
            chain (snapshot or delta files) into backing images. By 
default, this command
            attempts to flatten the entire chain.

In addition to "[base]" actually being "[--base base]" and "[top]" being 
"[--top top]", the description of what it does only applies to external 
snapshots. Similar things are wrong in the blockpull section.

>
>> However the results for that were:
>> # virsh blockcommit stretch /home/secure/virtual/stretch.qcow2 -top
>> stretchS3 -delete -wait
>> error: Scaled numeric value '-top' for <--bandwidth> option is malformed
>> or out of range
>>
>> which looks like virsh doesn't like the single dashes and is trying to
>> interpret them as positional options.
>>
>> I also did a
>>
>> # virsh domblklist stretch
>> Target     Source
>> ------------------------------------------------
>> vda        /home/secure/virtual/stretch.qcow2
>> hda        -
>>
>> and tried using vda instead of the full path in the blockcommit but got
>> the same error.
>>
>> Any ideas on what I'm doing wrong?
> Do you know for sure whether you have internal or external snapshots?
> And at this point, your questions are starting to wander more into
> libvirt territory.
>
Yes. I'm using internal snapshots. From your other e-mail, I gather that 
the (only) benefit to blockcommit with internal snapshots would be to 
reduce the size of the various tables recording changed blocks. Without 
a blockcommit, the L1 tables get progressively larger over time since 
they record all changes to the base file. Eventually the snapshots could 
become larger than the base image if I don't do a blockcommit.
