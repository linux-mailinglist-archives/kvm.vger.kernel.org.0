Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB2853F132
	for <lists+kvm@lfdr.de>; Mon,  6 Jun 2022 22:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234804AbiFFUxS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jun 2022 16:53:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231741AbiFFUws (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jun 2022 16:52:48 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64F70338B7;
        Mon,  6 Jun 2022 13:42:40 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 256KV1pI029119;
        Mon, 6 Jun 2022 20:42:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=lbaSShEGkI4JCswyOaLK2k7dTapx0AV7036Hk3OhJwE=;
 b=JSV7KtCY7/ifNq4rB26a7tyTcMPfR0+CkHfgJG3GnqGXNCAnRRJXey6mf98nU0jzidy9
 YEODAVohzc0C+YTFHZDpLRYPyLXJuVGbygPyqBbGSjwsmMrw9QkzSgd3qyKYhhbP1nJm
 zvQtxnfRPsjU3mJZrW4l9OyfBMLASzjNdJjtjYoIrrkWHmesxAi4iny8q004QHKcwhxn
 AhoV4yxfbMY2yUZJ6oOsPwe7xkxAIONd3oG1fRjHH5C7rk5tSlD0gNdwzwPT0c6nrhu7
 StDmdBiu+kXUI1xDfJIihMuNmXZZMutPcm7Nyve6zQBrqvvG0P7tciLSU6a5dMSD/OhK JQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ghpqfjbuy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Jun 2022 20:42:36 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 256KW27A032554;
        Mon, 6 Jun 2022 20:42:36 GMT
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ghpqfjbuv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Jun 2022 20:42:36 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 256KKGOo030481;
        Mon, 6 Jun 2022 20:42:35 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma03wdc.us.ibm.com with ESMTP id 3gfy19fwpf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Jun 2022 20:42:35 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 256KgYOu35520962
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 Jun 2022 20:42:34 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 533FF6A04F;
        Mon,  6 Jun 2022 20:42:34 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ABBCF6A047;
        Mon,  6 Jun 2022 20:42:31 +0000 (GMT)
Received: from [9.163.20.188] (unknown [9.163.20.188])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon,  6 Jun 2022 20:42:31 +0000 (GMT)
Message-ID: <5a2b4f8f-14b4-cbf2-7c22-ba7bbcd4e09f@linux.ibm.com>
Date:   Mon, 6 Jun 2022 16:42:31 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v9 00/21] KVM: s390: enable zPCI for interpretive
 execution
Content-Language: en-US
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, pbonzini@redhat.com, corbet@lwn.net,
        jgg@nvidia.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
References: <20220606203325.110625-1-mjrosato@linux.ibm.com>
In-Reply-To: <20220606203325.110625-1-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: WFXtV8rQRBX5Bmwtlid3r8AwwaBWsNT_
X-Proofpoint-GUID: lyTwiG177E8ZqAOvlxnKbrvOiwU_nyNv
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-06_06,2022-06-03_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 lowpriorityscore=0 phishscore=0 priorityscore=1501 mlxlogscore=709
 suspectscore=0 impostorscore=0 spamscore=0 malwarescore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206060081
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/6/22 4:33 PM, Matthew Rosato wrote:
> Enable interpretive execution of zPCI instructions + adapter interruption
> forwarding for s390x KVM vfio-pci.  This is done by triggering a routine
> when the VFIO group is associated with the KVM guest, transmitting to
> firmware a special token (GISA designation) to enable that specific guest
> for interpretive execution on that zPCI device.  Load/store interpreation
> enablement is then controlled by userspace (based upon whether or not a
> SHM bit is placed in the virtual function handle).  Adapter Event
> Notification interpretation is controlled from userspace via a new KVM
> ioctl.
> 
> By allowing intepretation of zPCI instructions and firmware delivery of
> interrupts to guests, we can reduce the frequency of guest SIE exits for
> zPCI.
> 
>  From the perspective of guest configuration, you passthrough zPCI devices
> in the same manner as before, with intepretation support being used by
> default if available in kernel+qemu.
> 
> Will follow up with a link the most recent QEMU series.
> 

Latest QEMU series:

https://lore.kernel.org/kvm/20220606203614.110928-1-mjrosato@linux.ibm.com/
