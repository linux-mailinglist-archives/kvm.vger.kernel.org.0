Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3E431B875C
	for <lists+kvm@lfdr.de>; Sat, 25 Apr 2020 17:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726135AbgDYPZd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Apr 2020 11:25:33 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59024 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbgDYPZd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 Apr 2020 11:25:33 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03PFIhhP123010;
        Sat, 25 Apr 2020 15:25:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=n/qwu83qdkcrW22LA/K+XFGGNTMGP6alS1n5GAoRuzg=;
 b=clT08kXrOJtYwmjTPjnBRqA+hLF0q/wnj4Tjd4OSQj+fo44Zxt2qjaDz+Wue6vJn/+mb
 fONoMSvB8pQMxWrrLP9vluE+B8u2EiWbgGec7k2fLj7SvKT86b2+SXO7JHb7D4SBNLyE
 3o6GZiox16xC7T5izYyLQFnf5NPBwB01QXetG2C1sqYjy/ZiTzyiwXKAh5eFvbV+zMvR
 9+sIJMBHQ+2EPG/Mxy7+oQe/d/Wi8waS5iy+DDirziIoHWU2C8zPKQLcKHn3G+IzJ96p
 8YdXJaE4UcRJ8a61jhibahZKhhflOsZieueAz9B6qboBcCxACOK5SN9ZY0PmpZdO15Om QA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 30md5ks46w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 25 Apr 2020 15:25:28 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03PFGjOf113808;
        Sat, 25 Apr 2020 15:25:28 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 30maasgwkv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 25 Apr 2020 15:25:28 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03PFPQik005511;
        Sat, 25 Apr 2020 15:25:26 GMT
Received: from [192.168.14.112] (/109.67.198.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 25 Apr 2020 08:25:26 -0700
Subject: Re: [PATCH v1 00/15] Add support for Nitro Enclaves
To:     "Paraschiv, Andra-Irina" <andraprs@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org
Cc:     Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        Alexander Graf <graf@amazon.de>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>, Balbir Singh <sblbir@amazon.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>, kvm@vger.kernel.org,
        ne-devel-upstream@amazon.com
References: <20200421184150.68011-1-andraprs@amazon.com>
 <18406322-dc58-9b59-3f94-88e6b638fe65@redhat.com>
 <ff65b1ed-a980-9ddc-ebae-996869e87308@amazon.com>
From:   Liran Alon <liran.alon@oracle.com>
Message-ID: <5c514de6-52a8-8532-23d9-e6b0cc9ac7eb@oracle.com>
Date:   Sat, 25 Apr 2020 18:25:21 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <ff65b1ed-a980-9ddc-ebae-996869e87308@amazon.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9602 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 suspectscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004250135
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9602 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 bulkscore=0
 adultscore=0 clxscore=1015 impostorscore=0 priorityscore=1501 phishscore=0
 lowpriorityscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004250135
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 23/04/2020 16:19, Paraschiv, Andra-Irina wrote:
>
> The memory and CPUs are carved out of the primary VM, they are 
> dedicated for the enclave. The Nitro hypervisor running on the host 
> ensures memory and CPU isolation between the primary VM and the 
> enclave VM.
I hope you properly take into consideration Hyper-Threading speculative 
side-channel vulnerabilities here.
i.e. Usually cloud providers designate each CPU core to be assigned to 
run only vCPUs of specific guest. To avoid sharing a single CPU core 
between multiple guests.
To handle this properly, you need to use some kind of core-scheduling 
mechanism (Such that each CPU core either runs only vCPUs of enclave or 
only vCPUs of primary VM at any given point in time).

In addition, can you elaborate more on how the enclave memory is carved 
out of the primary VM?
Does this involve performing a memory hot-unplug operation from primary 
VM or just unmap enclave-assigned guest physical pages from primary VM's 
SLAT (EPT/NPT) and map them now only in enclave's SLAT?

>
> Let me know if further clarifications are needed.
>
I don't quite understand why Enclave VM needs to be provisioned/teardown 
during primary VM's runtime.

For example, an alternative could have been to just provision both 
primary VM and Enclave VM on primary VM startup.
Then, wait for primary VM to setup a communication channel with Enclave 
VM (E.g. via virtio-vsock).
Then, primary VM is free to request Enclave VM to perform various tasks 
when required on the isolated environment.

Such setup will mimic a common Enclave setup. Such as Microsoft Windows 
VBS EPT-based Enclaves (That all runs on VTL1). It is also similar to 
TEEs running on ARM TrustZone.
i.e. In my alternative proposed solution, the Enclave VM is similar to 
VTL1/TrustZone.
It will also avoid requiring introducing a new PCI device and driver.

-Liran


