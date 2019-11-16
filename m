Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73B20FEA3C
	for <lists+kvm@lfdr.de>; Sat, 16 Nov 2019 03:21:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727290AbfKPCUy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Nov 2019 21:20:54 -0500
Received: from sender4-pp-o94.zoho.com ([136.143.188.94]:25481 "EHLO
        sender4-pp-o94.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727275AbfKPCUx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Nov 2019 21:20:53 -0500
X-Greylist: delayed 904 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Nov 2019 21:20:53 EST
ARC-Seal: i=1; a=rsa-sha256; t=1573869948; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=JBUmxxgjzN8WOocQWVm3N5+ERmqzaf0yI/IA49U6ReSrHSPxCQM0KCXO3PkPUCx56sqACUi21iEJCoFQXuoj2g5Foc9qb1kkFYKEtWIr/tx37+EYd3qxVsX3pUW0x511T1PymIzDX9JgDzF/2zwBHuNJXq0wlbwThx3fjrFm2Q0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1573869948; h=Content-Type:Content-Transfer-Encoding:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=/j/gkwINdDxxHTEkE2ogbZzlN5zsVwOINIvX0fpiNyc=; 
        b=dDnC5yUyQc9Qi1zztviQxsRDYuJ1VAcJ1wqAxF4McusE3ikY+zxCWEHoviQ80/sWniB1qyHumQaFtrjpksTYB1Y0QWj5EFScbIMCsi6FEqjJzL0a2z+5JPKeBkhslRUBBmF0xzQD7LZIVPrLoFDRurH5KlA3ju2+W5QuNErrZe8=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=zoho.com;
        spf=pass  smtp.mailfrom=ToddAndMargo@zoho.com;
        dmarc=pass header.from=<ToddAndMargo@zoho.com> header.from=<ToddAndMargo@zoho.com>
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; 
  s=zapps768; d=zoho.com; 
  h=to:from:subject:message-id:date:user-agent:mime-version:content-type; 
  b=bTF16uCrQFx2RXb9KFth711QLpIlxCc5TepKVN4u9zwgzH43Oa8FcjCkXtcqZgIpQx0EiCV7Irn2
    yVTRZnGFn1Ir+PT2jhNmL+6LlHoNHJSWxVFvzn0EKWLw2qUBE53R  
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1573869948;
        s=zm2019; d=zoho.com; i=ToddAndMargo@zoho.com;
        h=To:From:Subject:Message-ID:Date:MIME-Version:Content-Type:Content-Transfer-Encoding;
        l=699; bh=/j/gkwINdDxxHTEkE2ogbZzlN5zsVwOINIvX0fpiNyc=;
        b=Z8dhgLJmexYoTASzLnoP7eKlLchjoecU8rOovvVk/sJYnRUGjp+sDCzMl1T6hUKc
        y8HC3uP1ejV3WVn8W6wxx5gQdh/c5E46eWSKWEVG38kmfZKfGUJulbznbc0AZ9eMezk
        S25ts+A0Qxpt3K9JT6upsGtN6xVxWP67+4zxXk1I=
Received: from rn6.rent-a-nerd.local (50-37-21-182.grdv.nv.frontiernet.net [50.37.21.182]) by mx.zohomail.com
        with SMTPS id 1573869947638789.4777551508874; Fri, 15 Nov 2019 18:05:47 -0800 (PST)
To:     kvm@vger.kernel.org
From:   ToddAndMargo <ToddAndMargo@zoho.com>
Subject: Missing usb driver
Message-ID: <3dc8048f-1243-cfc2-bac1-773ffb70042a@zoho.com>
Date:   Fri, 15 Nov 2019 18:05:46 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi All,

Host:
    Fedora 31, x64
    qemu-kvm-4.1.0-5.fc31.x86_64
    USB Controller (USB3):

<controller type="usb" index="0" model="qemu-xhci" ports="15">
   <alias name="usb"/>
   <address type="pci" domain="0x0000" bus="0x00" slot="0x05" 
function="0x0"/>
</controller>


VM:
    Windows 7 Pro, SP1, x64


In my VM's device manager, it has a bang mark on
     Universal Serial Bus (USB) Controller

And Windows can not find the appropriate driver in:
     virtio-win-0.1.173.2.iso/virtio-win-gt-x64.msi
or the search the web find it.

And Windows can not find a USB device I redirect to it.

I don't have the problem with my Windows Ten -  1909 VM.

Any word of wisdom?

Many thanks,
-T


