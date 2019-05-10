Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3904119F14
	for <lists+kvm@lfdr.de>; Fri, 10 May 2019 16:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727931AbfEJOYj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 May 2019 10:24:39 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:43688 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727807AbfEJOYi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 May 2019 10:24:38 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4AE7L2p183701
        for <kvm@vger.kernel.org>; Fri, 10 May 2019 10:24:37 -0400
Received: from e35.co.us.ibm.com (e35.co.us.ibm.com [32.97.110.153])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2sdap50yeq-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 10 May 2019 10:24:37 -0400
Received: from localhost
        by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <farman@linux.ibm.com>;
        Fri, 10 May 2019 15:24:36 +0100
Received: from b03cxnp08026.gho.boulder.ibm.com (9.17.130.18)
        by e35.co.us.ibm.com (192.168.1.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 10 May 2019 15:24:35 +0100
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4AEOXFZ8388950
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 May 2019 14:24:33 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4BD6A7805C;
        Fri, 10 May 2019 14:24:33 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8DF6B7805E;
        Fri, 10 May 2019 14:24:32 +0000 (GMT)
Received: from [9.85.170.175] (unknown [9.85.170.175])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 10 May 2019 14:24:32 +0000 (GMT)
Subject: Re: [PATCH 7/7] s390/cio: Remove vfio-ccw checks of command codes
To:     Cornelia Huck <cohuck@redhat.com>,
        Pierre Morel <pmorel@linux.ibm.com>
Cc:     Farhan Ali <alifm@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
References: <20190503134912.39756-1-farman@linux.ibm.com>
 <20190503134912.39756-8-farman@linux.ibm.com>
 <8625f759-0a2d-09af-c8b5-5b312d854ba1@linux.ibm.com>
 <7c897993-d146-bf8e-48ad-11a914a04716@linux.ibm.com>
 <bba6c0a8-2346-cd99-b8ad-f316daac010b@linux.ibm.com>
 <7ac9fb43-8d7a-9e04-8cba-fa4c63dfc413@linux.ibm.com>
 <1f2e4272-8570-f93f-9d67-a43dcb00fc55@linux.ibm.com>
 <5c2b74a9-e1d9-cd63-1284-6544fa4376d9@linux.ibm.com>
 <20190510134718.3f727571.cohuck@redhat.com>
From:   Eric Farman <farman@linux.ibm.com>
Date:   Fri, 10 May 2019 10:24:31 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190510134718.3f727571.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19051014-0012-0000-0000-00001734B572
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011081; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000285; SDB=6.01201330; UDB=6.00630404; IPR=6.00982225;
 MB=3.00026828; MTD=3.00000008; XFM=3.00000015; UTC=2019-05-10 14:24:36
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19051014-0013-0000-0000-000057364BB4
Message-Id: <85fe257b-721a-f900-32fa-011845f242ed@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-09_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905100098
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/10/19 7:47 AM, Cornelia Huck wrote:
> On Wed, 8 May 2019 11:22:07 +0200
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> For the NOOP its clearly stated that it does not start a data transfer.
>> If we pin the CDA, it could then eventually be the cause of errors if
>> the address indicated by the CDA is not accessible.
>>
>> The NOOP is a particular CONTROL operation for which no data is transfered.
>> Other CONTROL operation may start a data transfer.
> 
> I've just looked at the documentation again.
> 
> The Olde Common I/O Device Commands document indicates that a NOOP
> simply causes channel end/device end.
> 
> The PoP seems to indicate that the cda is always checked (i.e. does it
> point to a valid memory area?), but I'm not sure whether the area that
> is pointed to is checked for accessibility etc. as well, even if the
> command does not transfer any data.
> 
> Has somebody tried to find out what happens on Real Hardware(tm) if you
> send a command that is not supposed to transfer any data where the cda
> points to a valid, but not accessible area?

Hrm...  The CDA itself?  I don't think so.  Since every CCW is converted 
to an IDAL in vfio-ccw, we guarantee that it's pointing to something 
valid at that point.

So, I hacked ccwchain_fetch_direct() to NOT set the IDAL flag in a NOP 
CCW, and to leave the CDA alone.  This means it will still contain the 
guest address, which is risky but hey it's a test system.  :)  (I 
offline'd a bunch of host memory too, to make sure I had some 
unavailable addresses.)

In my traces, the non-IDA NOP CCWs were issued to the host with and 
without the skip flag, with zero and non-zero counts, and with zero and 
non-zero CDAs.  All of them work just fine, including the ones who's 
addresses fall into the offline space.  Even the combination of no skip, 
non-zero count, and zero cda.

I modified that hack to do the same for a known invalid control opcode, 
and it seemed to be okay too.  We got an (expected) invalid command 
before we noticed any problem with the provided address.


> 
> In general, I think doing the translation (and probably already hitting
> errors there) is better than sending down a guest address.
> 

I mostly agree, but I have one test program that generates invalid GUEST 
addresses with its NOP CCWs, since it doesn't seem to care about whether 
they're valid or not.  So any attempt to pin them will end badly, which 
is why I call that opcode out in ccw_does_data_transfer(), and just send 
invalid IDAWs with it.

