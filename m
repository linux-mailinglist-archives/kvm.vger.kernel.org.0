Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3AC6196CED
	for <lists+kvm@lfdr.de>; Sun, 29 Mar 2020 13:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728108AbgC2LW3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 29 Mar 2020 07:22:29 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54484 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727984AbgC2LW3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 29 Mar 2020 07:22:29 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02TB3goL029039
        for <kvm@vger.kernel.org>; Sun, 29 Mar 2020 07:22:28 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3022nkf5a9-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Sun, 29 Mar 2020 07:22:27 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <raspl@linux.ibm.com>;
        Sun, 29 Mar 2020 12:22:18 +0100
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Sun, 29 Mar 2020 12:22:15 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02TBMMJL41288138
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 29 Mar 2020 11:22:22 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3E1F611C04C;
        Sun, 29 Mar 2020 11:22:22 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1DD0B11C04A;
        Sun, 29 Mar 2020 11:22:22 +0000 (GMT)
Received: from [9.145.153.64] (unknown [9.145.153.64])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sun, 29 Mar 2020 11:22:22 +0000 (GMT)
Subject: Re: [PATCH 7/7] tools/kvm_stat: add sample systemd unit file
From:   Stefan Raspl <raspl@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
References: <20200306114250.57585-1-raspl@linux.ibm.com>
 <20200306114250.57585-8-raspl@linux.ibm.com>
Date:   Sun, 29 Mar 2020 13:22:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200306114250.57585-8-raspl@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 20032911-0008-0000-0000-000003666FA1
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20032911-0009-0000-0000-00004A87ECC0
Message-Id: <7bfa384d-6739-f1c4-adbb-9e019dbe2948@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-29_04:2020-03-27,2020-03-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 malwarescore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 impostorscore=0 phishscore=0 priorityscore=1501 suspectscore=1
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003290106
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-03-06 12:42, Stefan Raspl wrote:
> From: Stefan Raspl <raspl@de.ibm.com>
> 
> Add a sample unit file as a basis for systemd integration of kvm_stat
> logs.
> Note that output is written to a rotating set of logfiles in .csv format
> for easy post-processing.
> 
> Signed-off-by: Stefan Raspl <raspl@linux.ibm.com>
> ---
>  tools/kvm/kvm_stat/kvm_stat.service | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
>  create mode 100644 tools/kvm/kvm_stat/kvm_stat.service
> 
> diff --git a/tools/kvm/kvm_stat/kvm_stat.service b/tools/kvm/kvm_stat/kvm_stat.service
> new file mode 100644
> index 000000000000..5854b285c669
> --- /dev/null
> +++ b/tools/kvm/kvm_stat/kvm_stat.service
> @@ -0,0 +1,15 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +
> +[Unit]
> +Description=Service that logs KVM kernel module trace events
> +Before=qemu-kvm.service
> +
> +[Service]
> +Type=simple
> +ExecStart=/root/kvm_stat -dtcr /var/log/kvm_stat.csv -T 1w -s 10
             ^^^^^^
Oooops - this isn't supposed to be a full qualified path, and especially not
this one.

Ciao,
Stefan

