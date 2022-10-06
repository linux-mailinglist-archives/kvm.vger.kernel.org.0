Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13C4A5F6135
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 08:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbiJFGuE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Oct 2022 02:50:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiJFGuD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Oct 2022 02:50:03 -0400
X-Greylist: delayed 903 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 05 Oct 2022 23:50:02 PDT
Received: from sender4-pp-o92.zoho.com (sender4-pp-o92.zoho.com [136.143.188.92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5FB2286DD
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 23:50:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1665038096; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=K1VaXgJk1pZN4D8OX80gwCo8MUt+2tezY2z0q+kVLS6fv7eHZhgLK3WUWXiwmXSN7721e7iXc8nC39/Pjk4dfutSlPlwzlEQ0CAnmt3Y+gwwBjZUvr2y/ysnzh8J1aGx6GtNXksXb2EQ49sFQ4P+8/GdYUw1IGM9sL72M0jfsj4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1665038096; h=Content-Type:Content-Transfer-Encoding:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=Z0Z/Rl9KnV4fKWEeuIrBhaVYERLM5ylNPrXukysva8E=; 
        b=gBLdyo8a8URzDCFGpexGDc+fJeh+Rb9sEhgUN0FRXvZCe4e6ciEyO1Xro3EmltpGyGn8ee1/FyrybZx4t8h98fJfJQk6cybQKINHNP12bXYv4ZoSVLLSkTaZ7QWxkOSWLv3CKjzhje3gCPHwsuIAUrZIfhijng3p/6AAPALfyqs=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=zoho.com;
        spf=pass  smtp.mailfrom=ToddAndMargo@zoho.com;
        dmarc=pass header.from=<ToddAndMargo@zoho.com>
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; 
  s=zapps768; d=zoho.com; 
  h=message-id:date:mime-version:user-agent:to:from:subject:content-type; 
  b=DYNRQCizMwUTpY9WNZOGP07Z8wLnj8XnvJ+2eWekfKsBdU9x5JoV5QUM/MinoJ2z5WV4r+Al9TJz
    Tkk/l3QXJZrqKpZnko2eWNYmNhslXb3jyZMsz/wOkfrIoSWBICSV  
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1665038096;
        s=zm2022; d=zoho.com; i=ToddAndMargo@zoho.com;
        h=Message-ID:Date:Date:MIME-Version:To:To:From:From:Subject:Subject:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To:Cc;
        bh=Z0Z/Rl9KnV4fKWEeuIrBhaVYERLM5ylNPrXukysva8E=;
        b=dHtotpOkJxCT4gGJwsZ+6mBH9q+9PEGgKV5lu/kowYBhe1SKLkq3Fig7Olaanzr5
        ZoCv8jw62bwRJdKpkR4j6Gr5OzHGRIndkwoczR1jSNkl1pHR8W8/SxXwsAleAOply0q
        R6Us/BkIGTyTpyPV+9Cad9UdYiEK8JdV8CUyf4Q8=
Received: from [192.168.250.117] (50-37-19-157.grdv.nv.frontiernet.net [50.37.19.157]) by mx.zohomail.com
        with SMTPS id 1665038094012595.2396817986686; Wed, 5 Oct 2022 23:34:54 -0700 (PDT)
Message-ID: <6e10d10b-8e64-0d4b-7bbf-f0478743b664@zoho.com>
Date:   Wed, 5 Oct 2022 23:34:53 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
To:     virt-tools-list@redhat.com, kvm@vger.kernel.org
Content-Language: en-US
From:   ToddAndMargo <ToddAndMargo@zoho.com>
Subject: Windows-11 22H2 upgrade problems
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64
X-ZohoMailClient: External
X-Spam-Status: No, score=-0.2 required=5.0 tests=BAYES_20,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgQWxsLA0KDQpGZWRvcmEgMzYNCnFlbXUta3ZtLTYuMi4wLTE1LmZjMzYueDg2XzY0DQpX
aW5kb3dzIDExIFBybw0KDQpBbnkgb2YgeW91IGd1eXMgaGF2aW5nIHRyb3VibGVzIHVwZ3Jh
ZGluZyBXaW5kb3dzLTExDQpidWlsZCAyMUgyIHRvIDIySDI/DQoNCkkgYW0gdXBncmFkaW5n
IGZyb20gdGhlIElTTzoNCiAgICBodHRwczovL3d3dy5taWNyb3NvZnQuY29tL2VuLXVzL3Nv
ZnR3YXJlLWRvd25sb2FkDQovd2luZG93czExDQoNCnVzaW5nIHRoZSBVUyBFbmdsaXNoIHZl
cnNpb246DQogICAgV2luMTFfMjJIMl9FbmdsaXNoX3g2NC5pc28NCg0KVGhlIGluc3RhbGwg
Z29lcyBhbGwgdGhlIHdheSB0aHJvdWdoIHRoZSBwcm9jZXNzIGFuZA0Kd2hlbiBJdCBkb2Vz
IGl0cyBmaW5hbCByZWJvb3QsIGl0IHRocm93cyB0aGUgIkluc3RhbGxhdGlvbg0KZmFpbGVk
IGluIFNBRkVfT1MgcGhhc2Ugd2l0aCBhbiBlcnJvciBkdXJpbmcgQk9PVA0Kb3BlcmF0aW9u
IDB4QzE5MDAxMDEgMHgyMDAxNyIuDQoNCkFjY29yZGluZyB0bw0KIA0KaHR0cHM6Ly93d3cu
eW91cndpbmRvd3NndWlkZS5jb20vMjAyMS8wOC90cm91Ymxlc2hvb3Qtd2luZG93cy0xMS11
cGdyYWRlLWZhaWx1cmVzLmh0bWwNCg0KdGhlIGxvZyBmaWxlIGZvciBTYWZlT1MgZXJyb3Jz
IGlzOg0KDQogICAgICAgICAgQzpcJFdpbmRvd3MufkJUXFNvdXJjZXNcUGFudGhlcjogRmls
ZSBuYW1lZA0KICAgICAgICAgIFNldHVwYWN0LmxvZyByZWNvcmRzIGFjdGlvbnMgaW4gdGhl
IGRvd25sZXZlbA0KICAgICAgICAgIGFuZCBTYWZlT1MgcGhhc2UuIEFzIHRoZSBsb2cgY2Fu
IGJlIHZlcnkNCiAgICAgICAgICBsYXJnZSwgc2V0dXAgYWxzbyBjcmVhdGVzIGEgZmlsZSBu
YW1lZA0KICAgICAgICAgIOKAnFNldHVwZXJyLmxvZ+KAnSB0aGF0IG9ubHkgaGFzIGluZm9y
bWF0aW9uDQogICAgICAgICAgYWJvdXQgdGhlIGVycm9ycyBlbmNvdW50ZXJlZCBieSB0aGUg
U2V0dXANCiAgICAgICAgICB0byBuYXJyb3cgdGhlIHNvdXJjZSBvZiB0aGUgcHJvYmxlbS4N
Cg0KQW5kIGZyb20gdGhlIHNhbWUgcmVmZXJlbmNlOg0KDQogICAgICBFcnJvciBDb2RlIFRy
b3VibGVzaG9vdGluZw0KDQogICAgICBDMTkwMDEwMS0yMDAxNyBBIGRyaXZlciBoYXMgY2F1
c2VkIGFuIGlsbGVnYWwNCiAgICAgIG9wZXJhdGlvbi4gTWFrZSBzdXJlIGFsbCB1bm5lY2Vz
c2FyeSBkZXZpY2VzDQogICAgICBhcmUgZGlzY29ubmVjdGVkIGV4Y2VwdCB0aGUga2V5Ym9h
cmQgYW5kIG1vdXNlLg0KICAgICAgUmVtb3ZlIGFueSAzcmQgcGFydHkgYW50aS12aXJ1cy5N
YWtlIHN1cmUgQklPUw0KICAgICAgZmlybXdhcmUgaXMgdXBkYXRlZCBvbiB0aGUgbW90aGVy
Ym9hcmQuDQoNCndoaWNoIG1lYW5zIHRoZXJlIGlzIGEgcHJvYmxlbSB3aXRoIGEgZHJpdmVy
LiBJIHJlbW92ZWQgZXZlcnl0aGluZyANCmV4Y2VwdCB0aGUga2V5Ym9hcmQgYW5kIG1vdXNl
LiBObyBqb3kuDQoNCkFuZCBJIGNhbid0IGZpbmQgYW55dGhpbmcgaW4gdGhlIGxvZ3MgZWl0
aGVyLg0KDQpJdCBhbHNvIGJlZ3MgdGhlIGlzc3VlIG9mIHdoeSAyMUgyIGlzICJzYWZlIiBh
bmQgMjJIMg0KaXMgbm90Lg0KDQpBbnkgb2YgeW91IGV4cGVyaWVuY2luZyB0aGlzPyAgSWYg
c28sIGhvdyBkaWQgeW91DQp3b3JrIGFyb3VuZCBpdD8NCg0KTWFueSB0aGFua3MsDQotVA0K
DQoNCi0tIA0Kfn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+DQpZZXN0ZXJkYXkgaXQgd29ya2Vk
Lg0KVG9kYXkgaXQgaXMgbm90IHdvcmtpbmcuDQpXaW5kb3dzIGlzIGxpa2UgdGhhdC4NCn5+
fn5+fn5+fn5+fn5+fn5+fn5+fn5+fg0K
