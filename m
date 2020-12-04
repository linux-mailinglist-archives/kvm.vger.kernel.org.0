Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 808142CE935
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 09:08:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728916AbgLDIIB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Dec 2020 03:08:01 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:32762 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728475AbgLDIIB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Dec 2020 03:08:01 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B486FB6035734;
        Fri, 4 Dec 2020 03:07:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=OrQsb4G3Mo6zPoHe7oS4IScRnebpdka+gnTXfO5aVEM=;
 b=Ckd8QqNf9o7QGG3Rq0o9BtjcwnYr4pT1F156RwMx1I07PskW5neLQjtw0m/6d7i1htBV
 CArH2xvTV6CwMMwFTXl9e3K8fF5VhLZu+QJPXbH+u6DdoZ+pcQoC7oE7Xp3jcQV4omdk
 E4EbSRf8LgVw2kyI2KVOPWVeI+MOJPhgNl0K1rInJPaUIzbuDyEk7b6PtVRsHQl5bXMk
 m4kU+OW/jRWpAJSchTuXEz+/392m3zyXC2WeTpwhenXxKSr4IqMI3cRzpCXRVyz3UPrl
 TLsiIXYFnpIUkDno4WPhs46wUdttXlkroJD93rW62wNEUrgRqAG5BGngMKvEWeVK/ppU Og== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35789ax7cv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Dec 2020 03:07:02 -0500
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0B486PjI036689;
        Fri, 4 Dec 2020 03:07:01 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35789ax79a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Dec 2020 03:07:01 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B47wMk4026881;
        Fri, 4 Dec 2020 08:06:58 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 35693xj1k3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Dec 2020 08:06:58 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B486tSW30212432
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Dec 2020 08:06:55 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0A5CB5204E;
        Fri,  4 Dec 2020 08:06:55 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.4.55])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id D12665204F;
        Fri,  4 Dec 2020 08:06:51 +0000 (GMT)
Subject: Re: [for-6.0 v5 00/13] Generalize memory encryption models
To:     David Gibson <david@gibson.dropbear.id.au>, pair@us.ibm.com,
        pbonzini@redhat.com, frankja@linux.ibm.com, brijesh.singh@amd.com,
        dgilbert@redhat.com, qemu-devel@nongnu.org
Cc:     Eduardo Habkost <ehabkost@redhat.com>, qemu-ppc@nongnu.org,
        rth@twiddle.net, thuth@redhat.com, berrange@redhat.com,
        mdroth@linux.vnet.ibm.com, Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        david@redhat.com, Richard Henderson <richard.henderson@linaro.org>,
        cohuck@redhat.com, kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        pasic@linux.ibm.com
References: <20201204054415.579042-1-david@gibson.dropbear.id.au>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <f2419585-4e39-1f3d-9e38-9095e26a6410@de.ibm.com>
Date:   Fri, 4 Dec 2020 09:06:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201204054415.579042-1-david@gibson.dropbear.id.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-04_02:2020-12-04,2020-12-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 spamscore=0 clxscore=1011 adultscore=0 priorityscore=1501 mlxlogscore=946
 lowpriorityscore=0 bulkscore=0 mlxscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012040046
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 04.12.20 06:44, David Gibson wrote:
> A number of hardware platforms are implementing mechanisms whereby the
> hypervisor does not have unfettered access to guest memory, in order
> to mitigate the security impact of a compromised hypervisor.
> 
> AMD's SEV implements this with in-cpu memory encryption, and Intel has
> its own memory encryption mechanism.  POWER has an upcoming mechanism
> to accomplish this in a different way, using a new memory protection
> level plus a small trusted ultravisor.  s390 also has a protected
> execution environment.
> 
> The current code (committed or draft) for these features has each
> platform's version configured entirely differently.  That doesn't seem
> ideal for users, or particularly for management layers.
> 
> AMD SEV introduces a notionally generic machine option
> "machine-encryption", but it doesn't actually cover any cases other
> than SEV.
> 
> This series is a proposal to at least partially unify configuration
> for these mechanisms, by renaming and generalizing AMD's
> "memory-encryption" property.  It is replaced by a
> "securable-guest-memory" property pointing to a platform specific

Can we do "securable-guest" ?
s390x also protects registers and integrity. memory is only one piece
of the puzzle and what we protect might differ from platform to 
platform.
