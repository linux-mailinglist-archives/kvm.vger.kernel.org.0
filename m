Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 270412BB21A
	for <lists+kvm@lfdr.de>; Fri, 20 Nov 2020 19:10:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729679AbgKTSHu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Nov 2020 13:07:50 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:25568 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729284AbgKTSHu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Nov 2020 13:07:50 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AKI1seg136543;
        Fri, 20 Nov 2020 13:07:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=hZJYjGbJ7SSpHfEryz4NfRrrOXGkbrELDzJma1AXbIQ=;
 b=LkseijrRHGNCQfU+0KXt2mw27pIboWpP4daQ7V/MaCgloJ/Nph3y7eg27D0nR3XMTtBy
 o3geZgLMc6owPnRaPvENQgygN2eY+6z6ig72VsqlOlS+vAGZsxq/vHbDwaGxsBYgL85z
 AczaHTzejhhY9zVzBwzIKF7uFpq6VDsKENDpQLoTO5kZAlUBRb/tziYk4TQ7zsc1Pwwp
 t2DeCQpLM2NuDPFuao+8O2OWskDK9+6WpdxUB/oXIrs9xenunGXg+O0CODGK6m+QDbN/
 0tRWsSnOmJou7nwZXU3nx+TkVdP7BmvuzNVGhIihvntDHnK6gp4mNu3LTG2xGxuTmUMq /Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34xdrw3kng-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Nov 2020 13:07:49 -0500
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0AKI5Ibe155441;
        Fri, 20 Nov 2020 13:07:49 -0500
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34xdrw3km3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Nov 2020 13:07:49 -0500
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AKI3XJa006091;
        Fri, 20 Nov 2020 18:07:46 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06fra.de.ibm.com with ESMTP id 34t6ghbcth-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Nov 2020 18:07:46 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AKI7hBL60752252
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Nov 2020 18:07:43 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 75B8FA4060;
        Fri, 20 Nov 2020 18:07:43 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 64280A4064;
        Fri, 20 Nov 2020 18:07:43 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 20 Nov 2020 18:07:43 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 0E732E23B0; Fri, 20 Nov 2020 19:07:43 +0100 (CET)
From:   Eric Farman <farman@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Eric Farman <farman@linux.ibm.com>
Subject: [PATCH v2 0/2] Connect request callback to mdev and vfio-ccw
Date:   Fri, 20 Nov 2020 19:07:38 +0100
Message-Id: <20201120180740.87837-1-farman@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-20_09:2020-11-20,2020-11-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 malwarescore=0 bulkscore=0 lowpriorityscore=0 spamscore=0 impostorscore=0
 phishscore=0 mlxlogscore=999 clxscore=1015 priorityscore=1501
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011200120
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There is a situation where removing all the paths from a device
connected via mdev and vfio-ccw can cause some difficulty.
Using the "chchp -c 0 xx" command to all paths will cause the
device to be removed from the configuration, and any guest
filesystem that is relying on that device will encounter errors.
Interestingly, the last chchp command will actually fail to
return to a shell prompt, and subsequent commands (another
chchp to bring the paths back online, chzdev, etc.) will also
hang because of the outstanding chchp.

The last chchp command drives to vfio_ccw_sch_remove() for every
affected mediated device, and ultimately enters an infinite loop
in vfio_del_group_dev(). This loop is broken when the guest goes
away, which in this case doesn't occur until the guest is shutdown.
This drives vfio_ccw_mdev_release() and thus vfio_device_release()
to wake up the vfio_del_group_dev() thread.

There is also a callback mechanism called "request" to ask a
driver (and perhaps user) to release the device, but this is not
implemented for mdev. So this adds one to that point, and then
wire it to vfio-ccw to pass it along to userspace. This will
gracefully drive the unplug code, and everything behaves nicely.

Despite the testing that was occurring, this doesn't appear related
to the vfio-ccw channel path handling code. I can reproduce this with
an older kernel/QEMU, which makes sense because the above behavior is
driven from the subchannel event codepaths and not the chpid events.
Because of that, I didn't flag anything with a Fixes tag, since it's
seemingly been this way forever.

RFC->V2:
 - Patch 1
   - Added a message when registering a device without a request callback
   - Changed the "if(!callback) return" to "if(callback) do" layout
   - Removed "unlikely" from "if(callback)" logic
   - Clarified some wording in the device ops struct commentary
 - Patch 2
   - Added Conny's r-b

Eric Farman (2):
  vfio-mdev: Wire in a request handler for mdev parent
  vfio-ccw: Wire in the request callback

 drivers/s390/cio/vfio_ccw_ops.c     | 26 ++++++++++++++++++++++++++
 drivers/s390/cio/vfio_ccw_private.h |  4 ++++
 drivers/vfio/mdev/mdev_core.c       |  4 ++++
 drivers/vfio/mdev/vfio_mdev.c       | 10 ++++++++++
 include/linux/mdev.h                |  4 ++++
 include/uapi/linux/vfio.h           |  1 +
 6 files changed, 49 insertions(+)

-- 
2.17.1

