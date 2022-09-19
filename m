Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF9835BC2DE
	for <lists+kvm@lfdr.de>; Mon, 19 Sep 2022 08:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbiISGez (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Sep 2022 02:34:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbiISGev (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Sep 2022 02:34:51 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58E706403;
        Sun, 18 Sep 2022 23:34:50 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28J5K5FN002757;
        Mon, 19 Sep 2022 06:34:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=hjxmirtzwK1s/13R3eClke7C6CcXu+MlHOs+1SEqztA=;
 b=btfQoXc/SATMeO6YcQfmQCyhR25Q91f4kXFjapfh8cJhmY550CoV88w6DhkM1wV56O9b
 w98gWSOxS8QsGJv3WxK2UmCUVzTszazeAyaf3UyszGfUqUWPB86QMTvG4qhJ0Gp5Dbzm
 9EVH5NZ5L3oGhmR84v4gioS7H/qn9EP4vLsef19q9/dz2rn00i741geU7WQhqCI5l0re
 rcmvpU89+9gjeSPV+wS1EaNCE9b/SxTM6X6J7xEoAODyHZd7URskrDTiZBBUKYDhJWkx
 FDZjlgoJWSywYng9WYJAKq0LGm3i/MWvZCJi+CORrZSxW2kEc3HGvS1mTOCVBpwYwsem ow== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jpj681ebv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Sep 2022 06:34:49 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28J6Yn2W027745;
        Mon, 19 Sep 2022 06:34:49 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jpj681eb6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Sep 2022 06:34:49 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28J6LjHn001959;
        Mon, 19 Sep 2022 06:34:46 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma01fra.de.ibm.com with ESMTP id 3jn5v8heh9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Sep 2022 06:34:46 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28J6UlBi45482396
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Sep 2022 06:30:47 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2EF704C04E;
        Mon, 19 Sep 2022 06:34:43 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8D4734C040;
        Mon, 19 Sep 2022 06:34:42 +0000 (GMT)
Received: from [9.171.62.75] (unknown [9.171.62.75])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 19 Sep 2022 06:34:42 +0000 (GMT)
Message-ID: <f6bdfd47-7977-0d67-5e24-a8e782c93370@linux.ibm.com>
Date:   Mon, 19 Sep 2022 08:34:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH linux-next] KVM: s390: pci: fix comparing pointer to 0
Content-Language: en-US
To:     cgel.zte@gmail.com, mjrosato@linux.ibm.com
Cc:     farman@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com, hca@linux.ibm.com,
        gor@linux.ibm.com, agordeev@linux.ibm.com, svens@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xu Panda <xu.panda@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
References: <20220918143603.209974-1-xu.panda@zte.com.cn>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20220918143603.209974-1-xu.panda@zte.com.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ndWqoLP3kLZrLLYyrqFcrqY_bk5P-y-c
X-Proofpoint-ORIG-GUID: mMOVYsgg0l2EJ4wIW74QWNhIgNGWtBg1
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-19_03,2022-09-16_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 mlxscore=0 adultscore=0 lowpriorityscore=0 suspectscore=0
 priorityscore=1501 spamscore=0 malwarescore=0 clxscore=1011
 mlxlogscore=935 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2209130000 definitions=main-2209190042
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am 18.09.22 um 16:36 schrieb cgel.zte@gmail.com:
> From: Xu Panda <xu.panda@zte.com.cn>
> 
> Comparing pointer whith NULL instead of comparing pointer to 0.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Xu Panda <xu.panda@zte.com.cn>

Thanks but there is already a fix queued (https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git/commit/?h=next&id=3ed2607b18cce86efed3a3c76fce89dc11184f62)
and your fix would still trigger checkpatch --strict warning.
> ---
>   arch/s390/kvm/pci.h | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/s390/kvm/pci.h b/arch/s390/kvm/pci.h
> index 3a3606c3a0fe..aadafa2e03d1 100644
> --- a/arch/s390/kvm/pci.h
> +++ b/arch/s390/kvm/pci.h
> @@ -46,8 +46,8 @@ extern struct zpci_aift *aift;
>   static inline struct kvm *kvm_s390_pci_si_to_kvm(struct zpci_aift *aift,
>                                                   unsigned long si)
>   {
> -       if (!IS_ENABLED(CONFIG_VFIO_PCI_ZDEV_KVM) || aift->kzdev == 0 ||
> -           aift->kzdev[si] == 0)
> +       if (!IS_ENABLED(CONFIG_VFIO_PCI_ZDEV_KVM) || aift->kzdev == NULL ||
> +           aift->kzdev[si] == NULL)
>                  return 0;
>          return aift->kzdev[si]->kvm;
>   };
