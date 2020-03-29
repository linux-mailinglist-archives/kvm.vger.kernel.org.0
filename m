Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57913196CEA
	for <lists+kvm@lfdr.de>; Sun, 29 Mar 2020 13:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727938AbgC2LWW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 29 Mar 2020 07:22:22 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:46686 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726087AbgC2LWV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 29 Mar 2020 07:22:21 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02TB3k9o029570
        for <kvm@vger.kernel.org>; Sun, 29 Mar 2020 07:22:20 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3022nkf58v-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Sun, 29 Mar 2020 07:22:20 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <raspl@linux.ibm.com>;
        Sun, 29 Mar 2020 12:22:07 +0100
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Sun, 29 Mar 2020 12:22:05 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02TBMF1e38338884
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 29 Mar 2020 11:22:15 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 88F5C11C052;
        Sun, 29 Mar 2020 11:22:15 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5F47511C04A;
        Sun, 29 Mar 2020 11:22:15 +0000 (GMT)
Received: from [9.145.153.64] (unknown [9.145.153.64])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sun, 29 Mar 2020 11:22:15 +0000 (GMT)
Subject: Re: [PATCH 0/7] tools/kvm_stat: add logfile support
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <20200306114250.57585-1-raspl@linux.ibm.com>
 <7f396df1-9589-6dd0-0adf-af4376aa8314@redhat.com>
 <d893c37d-705c-b9a1-cf98-db997edf3bce@linux.ibm.com>
 <5c350f55-64be-43fc-237d-7f71b4e9afdc@redhat.com>
 <7c8b614a-a7a1-d33e-8762-b06d4b2fd45b@linux.ibm.com>
 <d0143786-04e5-a9f8-bd87-d4c06cee1856@redhat.com>
From:   Stefan Raspl <raspl@linux.ibm.com>
Date:   Sun, 29 Mar 2020 13:22:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <d0143786-04e5-a9f8-bd87-d4c06cee1856@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 20032911-0020-0000-0000-000003BD91EF
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20032911-0021-0000-0000-000022162931
Message-Id: <cb983917-2c40-5002-b001-093f25e199a2@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-29_04:2020-03-27,2020-03-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 malwarescore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 impostorscore=0 phishscore=0 priorityscore=1501 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003290106
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-03-24 11:32, Paolo Bonzini wrote:
> On 24/03/20 09:26, Stefan Raspl wrote:
>> To be able to make use of the logfiles, we'd need to have the heading appear at
>> the top of each of the files.
>> Couldn't find much info on how logrotate works internally, but from what I
>> gathered, it seems it moves out the current logfile e.g. /var/log/kvm.log to
>> become /var/log/kvm.log.1, and sends a SIGHUP to kvm_stat so that it re-opens
>> /var/log/kvm.log - which would then start out with a header again.
>> That should work, but can you confirm that this is what you're suggesting?
>> If so: Keep the current semantics for the original logging mode, where we have
>> the heading printed every 20 lines? I would assume so, as that format is better
>> suited for console logs, but just in case you wanted that changed...
> 
> Yes to all. :)

I wrote a respective patch and tried it out, and found this approach not to be
workable for a number of reasons:
- The implicit buffering that takes place when redirecting output of kvm_stat in
  logging mode to a file messes up the format: logrotate moves the files on the
  disks, but there might be still data buffered that hasn't been written out
  yet. The SIGHUP triggers a new header to be written with the patch I came up
  with, but that header would sometimes appear only after a couple of lines
  written to the file, which messes up the format. Flushing stdout in the signal
  handler won't help, either - it's already too late by then.
- When restarting kvm_stat logging (e.g. after a reboot), appending to an
  existing file should suppress a new header from being written, or it would end
  up somewhere in the middle of the file, messing up the format. kvm_stat
  doesn't know that or where its output is redirected to, so no chance of
  suppressing it within kvm_stat. We would probably require some kind of wrapper
  script (and possibly an extra cmd-line option to suppress the header on
  start).
- I was surprised to realize that SIGHUP is actually not part of logrotate -
  one has to write that manually into the logrotate config as a postrotate...
  and I'll openly admit that writing a respective killall-command that aims at a
  python script doesn't seem to be trivial...

Any idea how to address these issues?

As much as I sympathize with re-use of existing components, I'd like to point
out that my original patch was also re-using existing python code for rotating
logs, and made things just _so_ much easier from a user perspective.

Ciao,
Stefan

