Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A29112F3652
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 18:01:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404908AbhALQ7m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 11:59:42 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:62388 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725843AbhALQ7m (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Jan 2021 11:59:42 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10CGX5j5125279;
        Tue, 12 Jan 2021 11:58:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=uh876IqNflvIMzX2XbLcnuP6OFHWTNTN+tuwbVXYpmA=;
 b=MoPogGAIXodCFEPSTcdlXZ6iRV36tBtdrdZZzfXduRlYYbmn/aJNZH1ZV8xzKVgNblSn
 D2a60IOPP2m++H+Wpk8Si4wnVXIA2K7zbq0T+TaFzzrmcyNsCkUGreHXWffahei7b8Ew
 FHJi/1J8lZWRIKDJl4eqTqgTHj2JEmCOBcCoxpyuVAum5y3mPUOPxGQD16vxV3EMZdPc
 TXDZZ8u+kG4kKoi3FHdcJX53vejhczCcs5gNpOANZoTS1glR6elBHPgmVQAamAhuUIa3
 GcKDgybr/pURIxnkJoa44y0g17X3CogtS7gVaRGbtKBdSmuK5RkkMa1OG+s2WXGNFrj6 AA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 361fba8q73-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 11:58:59 -0500
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10CGX9Cb125442;
        Tue, 12 Jan 2021 11:58:59 -0500
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 361fba8q68-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 11:58:58 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10CGwKq8027442;
        Tue, 12 Jan 2021 16:58:56 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03fra.de.ibm.com with ESMTP id 35y448a0mc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 16:58:56 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10CGwr6W44237200
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jan 2021 16:58:53 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 53F4F11C04A;
        Tue, 12 Jan 2021 16:58:53 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 90E8611C058;
        Tue, 12 Jan 2021 16:58:52 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.60.135])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Tue, 12 Jan 2021 16:58:52 +0000 (GMT)
Date:   Tue, 12 Jan 2021 17:58:50 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v13 12/15] s390/zcrypt: Notify driver on config changed
 and scan complete callbacks
Message-ID: <20210112175850.589d9e4d.pasic@linux.ibm.com>
In-Reply-To: <20201223011606.5265-13-akrowiak@linux.ibm.com>
References: <20201223011606.5265-1-akrowiak@linux.ibm.com>
        <20201223011606.5265-13-akrowiak@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-12_12:2021-01-12,2021-01-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 clxscore=1015
 priorityscore=1501 malwarescore=0 adultscore=0 mlxscore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101120095
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 22 Dec 2020 20:16:03 -0500
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> This patch intruduces an extension to the ap bus to notify device drivers
> when the host AP configuration changes - i.e., adapters, domains or
> control domains are added or removed. To that end, two new callbacks are
> introduced for AP device drivers:
> 
>   void (*on_config_changed)(struct ap_config_info *new_config_info,
>                             struct ap_config_info *old_config_info);
> 
>      This callback is invoked at the start of the AP bus scan
>      function when it determines that the host AP configuration information
>      has changed since the previous scan. This is done by storing
>      an old and current QCI info struct and comparing them. If there is any
>      difference, the callback is invoked.
> 
>      Note that when the AP bus scan detects that AP adapters, domains or
>      control domains have been removed from the host's AP configuration, it
>      will remove the associated devices from the AP bus subsystem's device
>      model. This callback gives the device driver a chance to respond to
>      the removal of the AP devices from the host configuration prior to
>      calling the device driver's remove callback. The primary purpose of
>      this callback is to allow the vfio_ap driver to do a bulk unplug of
>      all affected adapters, domains and control domains from affected
>      guests rather than unplugging them one at a time when the remove
>      callback is invoked.
> 
>   void (*on_scan_complete)(struct ap_config_info *new_config_info,
>                            struct ap_config_info *old_config_info);
> 
>      The on_scan_complete callback is invoked after the ap bus scan is
>      complete if the host AP configuration data has changed.
> 
>      Note that when the AP bus scan detects that adapters, domains or
>      control domains have been added to the host's configuration, it will
>      create new devices in the AP bus subsystem's device model. The primary
>      purpose of this callback is to allow the vfio_ap driver to do a bulk
>      plug of all affected adapters, domains and control domains into
>      affected guests rather than plugging them one at a time when the
>      probe callback is invoked.
> 
> Please note that changes to the apmask and aqmask do not trigger
> these two callbacks since the bus scan function is not invoked by changes
> to those masks.
> 
> Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>

Reviewed-by: Halil Pasic <pasic@linux.ibm.com>

[..]
