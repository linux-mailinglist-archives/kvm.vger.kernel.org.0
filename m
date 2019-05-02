Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE1A113A5
	for <lists+kvm@lfdr.de>; Thu,  2 May 2019 09:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726186AbfEBHEN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 May 2019 03:04:13 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:37314 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725795AbfEBHEN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 May 2019 03:04:13 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x426x4ov077595;
        Thu, 2 May 2019 07:04:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=A60QWLinX2B6/JLwfGxKN/s9kZ54SgkNOck1R9AcbB0=;
 b=PzIbPyAB7ZEWAYboNqv4u30zZ3ZFODv0JgNeS7aNGwE5oOPZDO3jhPaoMEvgTj3NUai7
 G/e4ZXvj5jwwFR+gqTU896RRsK534QqLBrX6BkashGYrHZj/joTqBJh5g1V9/HLGin+V
 vipErcmnmyqTRQb6SWQOXgo3b3h33ZyyzX4BLOMybEF6oxuz23VkiS6dYwONTHgRfj9O
 dGQ3ncmj0Fu7YJNv80k+avcKLRlvrORQQPfjRmXkErMJeoaBzyNevhwhXdSaAhS6YZnC
 Trd6Ax6EJOtlDD7Q+0RIQKXeHbpgMPROIbsB6lZkD+tfAWN80BzyIAtgB7aVQYFrqQ9d LA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2s6xhyektj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 May 2019 07:04:03 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4273JS7190246;
        Thu, 2 May 2019 07:04:02 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2s6xhgn4fy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 May 2019 07:04:02 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x42741HP031724;
        Thu, 2 May 2019 07:04:01 GMT
Received: from mwanda (/196.97.155.240)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 02 May 2019 00:04:00 -0700
Date:   Thu, 2 May 2019 10:03:53 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     clg@kaod.org
Cc:     kvm@vger.kernel.org
Subject: [bug report] KVM: Introduce a 'release' method for KVM devices
Message-ID: <20190502070353.GA10616@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9244 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=581
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905020055
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9244 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=607 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905020054
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Cédric Le Goater,

This is a semi-automatic email about new static checker warnings.

The patch 2bde9b3ec8bd: "KVM: Introduce a 'release' method for KVM 
devices" from Apr 18, 2019, leads to the following Smatch complaint:

    arch/x86/kvm/../../../virt/kvm/kvm_main.c:2943 kvm_device_release()
    warn: variable dereferenced before check 'dev' (see line 2941)

arch/x86/kvm/../../../virt/kvm/kvm_main.c
  2938  static int kvm_device_release(struct inode *inode, struct file *filp)
  2939  {
  2940		struct kvm_device *dev = filp->private_data;
  2941		struct kvm *kvm = dev->kvm;
                                  ^^^^^^^^
Dereference.

  2942	
  2943		if (!dev)
                    ^^^^
Checked too late.

  2944			return -ENODEV;
  2945	
  2946          if (dev->kvm != kvm)
                    ^^^^^^^^^^^^^^^
What is this testing?  We just set "kvm = dev->kvm;" at the start.

  2947                  return -EPERM;
  2948  
  2949          if (dev->ops->release) {
  2950                  mutex_lock(&kvm->lock);
  2951                  list_del(&dev->vm_node);
  2952                  dev->ops->release(dev);
  2953                  mutex_unlock(&kvm->lock);
  2954          }
  2955  
  2956          kvm_put_kvm(kvm);
  2957          return 0;
  2958  }

regards,
dan carpenter
