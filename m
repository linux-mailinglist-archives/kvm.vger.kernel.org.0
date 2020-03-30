Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7569F197BC1
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 14:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729972AbgC3MYh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 08:24:37 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:25652 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729881AbgC3MYg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Mar 2020 08:24:36 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02UC2ZBC145053
        for <kvm@vger.kernel.org>; Mon, 30 Mar 2020 08:24:36 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3022jtrqes-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 30 Mar 2020 08:24:35 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <raspl@linux.ibm.com>;
        Mon, 30 Mar 2020 13:24:21 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 30 Mar 2020 13:24:20 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02UCOW3E29818904
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Mar 2020 12:24:32 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 07FBA11C054;
        Mon, 30 Mar 2020 12:24:32 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D864511C050;
        Mon, 30 Mar 2020 12:24:31 +0000 (GMT)
Received: from [9.145.41.59] (unknown [9.145.41.59])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 30 Mar 2020 12:24:31 +0000 (GMT)
Subject: Re: [PATCH 0/7] tools/kvm_stat: add logfile support
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <20200306114250.57585-1-raspl@linux.ibm.com>
 <7f396df1-9589-6dd0-0adf-af4376aa8314@redhat.com>
 <d893c37d-705c-b9a1-cf98-db997edf3bce@linux.ibm.com>
 <5c350f55-64be-43fc-237d-7f71b4e9afdc@redhat.com>
 <7c8b614a-a7a1-d33e-8762-b06d4b2fd45b@linux.ibm.com>
 <d0143786-04e5-a9f8-bd87-d4c06cee1856@redhat.com>
 <cb983917-2c40-5002-b001-093f25e199a2@linux.ibm.com>
 <341997c9-7bda-c699-3a85-8f98e4500dbe@redhat.com>
From:   Stefan Raspl <raspl@linux.ibm.com>
Date:   Mon, 30 Mar 2020 14:24:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <341997c9-7bda-c699-3a85-8f98e4500dbe@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 20033012-0020-0000-0000-000003BE3C50
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20033012-0021-0000-0000-00002216D7E1
Message-Id: <43d8da60-9f1c-7e0b-4efd-14f2a600d58d@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-30_01:2020-03-27,2020-03-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 bulkscore=0 phishscore=0 malwarescore=0 priorityscore=1501 suspectscore=0
 clxscore=1015 mlxlogscore=999 impostorscore=0 lowpriorityscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003300111
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-03-30 12:43, Paolo Bonzini wrote:
> On 29/03/20 13:22, Stefan Raspl wrote:
>> I wrote a respective patch and tried it out, and found this approach not to be
>> workable for a number of reasons:
>> - The implicit buffering that takes place when redirecting output of kvm_stat in
>>   logging mode to a file messes up the format: logrotate moves the files on the
>>   disks, but there might be still data buffered that hasn't been written out
>>   yet. The SIGHUP triggers a new header to be written with the patch I came up
>>   with, but that header would sometimes appear only after a couple of lines
>>   written to the file, which messes up the format. Flushing stdout in the signal
>>   handler won't help, either - it's already too late by then.
> 
> I don't understand this.  Unless you were using copytruncate, the
> sequence should be:
> 
> - logrotate moves file A to B
> 
> - your file descriptor should point to B, so kvm_stat keeps writing to
> file B
> 
> - you send the signal to kvm_stat
> 
> - kvm_stat closes file B, so all pending records are written
> 
> - kvm_stat reopens file A and writes the header.

I was using copytruncate indeed. But removing it, things still don't work
(kvm_stat continues to write to B). But maybe there's a deeper misunderstanding:
My assumption is you'd do something like 'kvm_stat -l > /var/log/kvm_stat.txt'.
If so, how could kvm_stat ever be aware of where its output gets redirected to,
nevermind open/closing any of those files? Or did you mean kvm_stat should close
& open stdout?!

> If you have a race of some sort, try having the signal handler do
> nothing but set a flag that is examined in the main loop.
> 
>> - When restarting kvm_stat logging (e.g. after a reboot), appending to an
>>   existing file should suppress a new header from being written, or it would end
>>   up somewhere in the middle of the file, messing up the format. kvm_stat
>>   doesn't know that or where its output is redirected to, so no chance of
>>   suppressing it within kvm_stat. We would probably require some kind of wrapper
>>   script (and possibly an extra cmd-line option to suppress the header on
>>   start).
> 
> You could stat the output file, and suppress the header if it is a
> regular non-empty file.  But it would be a problem anyway if the header
> has changed since the last boot, which prompts the stupid and lazy
> question: how does your series deal with this?

How could we stat the output file if kvm_stat is just writing to a console?
My previous patch series was built on top of the RotatingFileHandler class,
which was making sure that we wouldn't repeat the header in case we're appending
to an existing file.
I don't believe there is any way of dealing with changes in the fields selected
- unless we just rotate files whenever we restart logging to be on the safe
side. But with the target scenario at hand (routinely logging in the background
as part of systemd or the like), the only plausible scenario would be that we
introduce new fields that get printed by kvm_stat per default.

> This one seems the biggest of the three problems to me.
> 
>> - I was surprised to realize that SIGHUP is actually not part of logrotate -
>>   one has to write that manually into the logrotate config as a postrotate...
>>   and I'll openly admit that writing a respective killall-command that aims at a
>>   python script doesn't seem to be trivial...
> 
> This one is easy, put "ExecReload=/bin/kill -HUP $MAINPID" in the
> systemd unit and use "systemctl reload kvm_stat.service" in the
> postrotate command.

Ah, OK - was searching for a solution within the realms of logrotate.

>> As much as I sympathize with re-use of existing components, I'd like to point
>> out that my original patch was also re-using existing python code for rotating
>> logs, and made things just _so_ much easier from a user perspective.
> 
> I understand that, yes.  My request was more about not requiring
> kvm_stat-specific configuration than about reusing existing components,
> though.

Taking a step back and looking at the tightly integrated kvm_stat - logrotate -
systemd approach outlined above, I'd bet most users would prefer a
self-contained solution in kvm_stat that merely requires adding a single extra
command line switch. And they can still add systemd on top, which wouldn't need
to interact with any of the other components except to start kvm_stat initally.

Ciao,
Stefan

