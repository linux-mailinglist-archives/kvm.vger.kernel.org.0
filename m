Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36AF2287196
	for <lists+kvm@lfdr.de>; Thu,  8 Oct 2020 11:33:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726304AbgJHJdV convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 8 Oct 2020 05:33:21 -0400
Received: from loire.is.ed.ac.uk ([129.215.16.10]:58282 "EHLO
        loire.is.ed.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725852AbgJHJdV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Oct 2020 05:33:21 -0400
Received: from exseed.ed.ac.uk (hbdkb3.is.ed.ac.uk [129.215.235.37])
        by loire.is.ed.ac.uk (8.14.7/8.14.7) with ESMTP id 0989XBim022186
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 8 Oct 2020 10:33:13 +0100
Received: from hbdat3.is.ed.ac.uk (129.215.235.38) by hbdkb3.is.ed.ac.uk
 (129.215.235.37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Thu, 8 Oct 2020
 10:32:52 +0100
Received: from EUR03-VE1-obe.outbound.protection.outlook.com (104.47.9.59) by
 hbdat3.is.ed.ac.uk (129.215.235.38) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Thu, 8 Oct 2020 10:32:52 +0100
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cbna8jBR232KeHUcgM9R4umKBQagquoZP6Xgth4In6jMcO9Hq17JYoqd7atTWqzKLa/WK/M9bxPhkPWqVqZAuObwz8SexpWDfcMFWjc0hmKbWhyCWF+pwXRvX9fIO8x0Cz37PqLVgopUrbCZihN3eAlHvko4OQfSKbeeo0v7h6Q8y6iUVaEPioGq9w2L98hi1NvHj+DHPyciIg7nqVnhwerSUdqtAQEKplMLlLEwO6jMM7rRMwforOb2RsPcC8EtfumeM32Ayr1hhv1X3gZNKAdrPTWBOWHKcwrMZetmJfQqeRbAIncJiX+FKMNwpxp5r+Iuky0X7lI81z7Dkg25cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n7dPhnQN1wt8kuY2HJBu8aVom3glChCXsK0YxGRsq18=;
 b=J81ZI2HWr9CPjqBuH6Uf4wA78/d1TpowcxXe9h0tuErAzZIA3pbH8SzzpPX+SCrGxgzr6PXNVrBmE9RRZwdDBy3wSjMQ+1wtXV1ycb6npbSv84maDWFq7htyJDLftgpyyKF0rWNUsy4LnIK602q6jOzZFye3jA2e9cJl4D28zLZ46V11LAPYRIPXgz62e399y1NwEEPOkLUNt6499EdPSppoWiYhW2CiDQoqZnqb4xzMLrjhLtbr2aUpFSczvZ/eGd08m7bhPqgbnc5wg3xbF8QstlZNCFj+j2eqVIgZ78U4ZMnfD0O23lNTbzOkWZl+VnHcmI721xMW17GoDKEUSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ed.ac.uk; dmarc=pass action=none header.from=ed.ac.uk;
 dkim=pass header.d=ed.ac.uk; arc=none
Received: from AM7PR05MB7076.eurprd05.prod.outlook.com (2603:10a6:20b:1af::19)
 by AM6PR05MB4261.eurprd05.prod.outlook.com (2603:10a6:209:48::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.37; Thu, 8 Oct
 2020 09:32:50 +0000
Received: from AM7PR05MB7076.eurprd05.prod.outlook.com
 ([fe80::c9af:88a9:6fef:7b63]) by AM7PR05MB7076.eurprd05.prod.outlook.com
 ([fe80::c9af:88a9:6fef:7b63%5]) with mapi id 15.20.3433.045; Thu, 8 Oct 2020
 09:32:50 +0000
From:   BARBALACE Antonio <antonio.barbalace@ed.ac.uk>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "will@kernel.org" <will@kernel.org>,
        "julien.thierry.kdev@gmail.com" <julien.thierry.kdev@gmail.com>
Subject: [KVMTOOL][PATCHv2] vhost-net: enable multiqueue support
Thread-Topic: [KVMTOOL][PATCHv2] vhost-net: enable multiqueue support
Thread-Index: AdadVWEwOQ9y4UqITcOAQyOmbaWZGw==
Date:   Thu, 8 Oct 2020 09:32:50 +0000
Message-ID: <AM7PR05MB7076C36757D01A87A86FF330CC0B0@AM7PR05MB7076.eurprd05.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=ed.ac.uk;
x-originating-ip: [82.38.204.131]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d19d1ac3-1ba5-4960-7030-08d86b6d2025
x-ms-traffictypediagnostic: AM6PR05MB4261:
x-microsoft-antispam-prvs: <AM6PR05MB4261160CA560B8437F0D12E0CC0B0@AM6PR05MB4261.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0txeHuX0KNG5RecswD/yAnJNILFNTAcUmteTV+gKOsg4W+CynnAo2tPdpFlaN7xsg24Ktw/oJqZ2MAlIOzkRHeC1YBNT0IRin2u65chAOmejVfVhA7OA8oaRyHNABjyDbuq+PNkxGXX2lu6Npr1XopZ0DflVk1KPl53DcgpMKbHblsY3UNKfeVF4lcEUizHuak6G0UxpgGElKCU2m6NH1OnIIVcjGZKqfrikf9rvkada1n1oZ/tbHOUp0hqWVBJbevIMiF3qVzqZWztRLOwNctQCgSys9h0CBK9RZ8wBJs5tfGI89d7rhpCPm2KyhDSo5DnEmHbRoKIZIyPMt4sIbg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR05MB7076.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(366004)(39860400002)(376002)(136003)(52536014)(71200400001)(9686003)(5660300002)(8676002)(83380400001)(6916009)(54906003)(8936002)(4326008)(26005)(76116006)(478600001)(316002)(55016002)(6506007)(64756008)(7696005)(2906002)(33656002)(66476007)(186003)(86362001)(66946007)(66556008)(786003)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: m1/QI39JQqP7ObKqcU5KH+iZm+EwrDw0zDq+c8Ai69g7aBx75mpMuMsZnKj2wxcRiy4hVY7ERHWW/onnRn//J9LK2lxlp9ATu+gujBgxahuHZRA/LprnHDNP4Za9aHDZnejM0frADbpP5q3CNuonzTltnEy5YI64uxTxodP1vcX37irqoYM3N/4SxppCnbass8Lmt1ZITVyMeImuKDNJ2KMkZqtabDuQ9BcvINMzkS3G0UjL2FAqc8QY+fOF+NpLfugRTccO3lrsU+dLcgUGVRqrd5eiH8Z7nKFB6aUnmhxLV6poBnIBbuZD4DG0A1DkwapsCjJr9rkPkMarRwIMJpEn/TgmWajCYOSfhFfsCGKCNvbNeTt9Jz5JGBxNkj6xMBy0zjjTRjVEEETtGzx3W4UKUYTx+uhQiI+j5r1zDjShSU5GZXJqc1Pfpn5GWZMvKz6H7PYQwTjf339rQq5XmfTN+BPx+vJYXcmzVZMwsBfd8NzK+yiyhs4LsGEGGdmjxslsBNpfvoMJjZ0Mgrmj/SkCCmugT2DSIsfae2s6n/ZH50mUDlz9w61QJx1x6gcDXkObjEu3fWsUNgqWZ8ro+qvFQtwNU9z0CFCsjQpelkQMAkR+0ndDKWapd9ATdj+DyypTfJhCaqtjs8pYNsXYSQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM7PR05MB7076.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d19d1ac3-1ba5-4960-7030-08d86b6d2025
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2020 09:32:50.7189
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 2e9f06b0-1669-4589-8789-10a06934dc61
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: upfMp6Yp7PRtTCBLcPypCMU2J8abLRJr7ghvIByzy/AbialKEZrUVPgxaTGH1Sz97RX8Ee89fVQMLR4sZ+yEsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB4261
X-OriginatorOrg: ed.ac.uk
X-Edinburgh-Scanned: at loire.is.ed.ac.uk
    with MIMEDefang 2.84, Sophie, Sophos Anti-Virus, Clam AntiVirus
X-Scanned-By: MIMEDefang 2.84 on 129.215.16.10
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch enables vhost-net multi queue support in kvmtool, without any Linux kernel modification.
The patch takes the same approach as QEMU -- for each queue pair a new /dev/vhost-net fd is created.
Fds are kept in ndev->vhost_fds, with ndev->vhost_fd == ndev->vhost_fds[0] (to avoid further modification to the existent source code).
Thanks, Antonio Barbalace

----

diff --git a/virtio/net.c b/virtio/net.c
index 1ee3c19..acdd741 100644
--- a/virtio/net.c
+++ b/virtio/net.c
@@ -58,6 +58,7 @@ struct net_dev {
 u32features, queue_pairs;

 intvhost_fd;
+intvhost_fds[VIRTIO_NET_NUM_QUEUES];
 inttap_fd;
 chartap_name[IFNAMSIZ];
 booltap_ufo;
@@ -512,6 +513,8 @@ static int virtio_net__vhost_set_features(struct net_dev *ndev)
 {
 u64 features = 1UL << VIRTIO_RING_F_EVENT_IDX;
 u64 vhost_features;
+u32 i;
+int r = 0;

 if (ioctl(ndev->vhost_fd, VHOST_GET_FEATURES, &vhost_features) != 0)
 die_perror("VHOST_GET_FEATURES failed");
@@ -521,7 +524,13 @@ static int virtio_net__vhost_set_features(struct net_dev *ndev)
 has_virtio_feature(ndev, VIRTIO_NET_F_MRG_RXBUF))
 features |= 1UL << VIRTIO_NET_F_MRG_RXBUF;

-return ioctl(ndev->vhost_fd, VHOST_SET_FEATURES, &features);
+for (i = 0 ; i < ndev->queue_pairs ; i++) {
+r = ioctl(ndev->vhost_fds[i], VHOST_SET_FEATURES, &features);
+if (r < 0)
+break;
+}
+
+return r;
 }

 static void set_guest_features(struct kvm *kvm, void *dev, u32 features)
@@ -578,13 +587,13 @@ static bool is_ctrl_vq(struct net_dev *ndev, u32 vq)
 static int init_vq(struct kvm *kvm, void *dev, u32 vq, u32 page_size, u32 align,
    u32 pfn)
 {
-struct vhost_vring_state state = { .index = vq };
+struct vhost_vring_state state = { .index = vq % 2 };
 struct net_dev_queue *net_queue;
 struct vhost_vring_addr addr;
 struct net_dev *ndev = dev;
 struct virt_queue *queue;
 void *p;
-int r;
+int r, vq_fd = vq / 2;

 compat__remove_message(compat_id);

@@ -619,23 +628,24 @@ static int init_vq(struct kvm *kvm, void *dev, u32 vq, u32 page_size, u32 align,
 if (queue->endian != VIRTIO_ENDIAN_HOST)
 die_perror("VHOST requires the same endianness in guest and host");

-state.num = queue->vring.num;
-r = ioctl(ndev->vhost_fd, VHOST_SET_VRING_NUM, &state);
+state.num = queue->vring.num;
+r = ioctl(ndev->vhost_fds[vq_fd], VHOST_SET_VRING_NUM, &state);
 if (r < 0)
 die_perror("VHOST_SET_VRING_NUM failed");
+
 state.num = 0;
-r = ioctl(ndev->vhost_fd, VHOST_SET_VRING_BASE, &state);
+r = ioctl(ndev->vhost_fds[vq_fd], VHOST_SET_VRING_BASE, &state);
 if (r < 0)
 die_perror("VHOST_SET_VRING_BASE failed");

 addr = (struct vhost_vring_addr) {
-.index = vq,
+.index = vq % 2,
 .desc_user_addr = (u64)(unsigned long)queue->vring.desc,
 .avail_user_addr = (u64)(unsigned long)queue->vring.avail,
 .used_user_addr = (u64)(unsigned long)queue->vring.used,
 };

-r = ioctl(ndev->vhost_fd, VHOST_SET_VRING_ADDR, &addr);
+r = ioctl(ndev->vhost_fds[vq_fd], VHOST_SET_VRING_ADDR, &addr);
 if (r < 0)
 die_perror("VHOST_SET_VRING_ADDR failed");

@@ -659,7 +669,7 @@ static void exit_vq(struct kvm *kvm, void *dev, u32 vq)
  */
 if (ndev->vhost_fd && !is_ctrl_vq(ndev, vq)) {
 pr_warning("Cannot reset VHOST queue");
-ioctl(ndev->vhost_fd, VHOST_RESET_OWNER);
+ioctl(ndev->vhost_fds[(vq /2)], VHOST_RESET_OWNER);
 return;
 }

@@ -682,7 +692,7 @@ static void notify_vq_gsi(struct kvm *kvm, void *dev, u32 vq, u32 gsi)
 return;

 file = (struct vhost_vring_file) {
-.index= vq,
+.index= vq % 2,
 .fd= eventfd(0, 0),
 };

@@ -693,29 +703,30 @@ static void notify_vq_gsi(struct kvm *kvm, void *dev, u32 vq, u32 gsi)
 queue->irqfd = file.fd;
 queue->gsi = gsi;

-r = ioctl(ndev->vhost_fd, VHOST_SET_VRING_CALL, &file);
+r = ioctl(ndev->vhost_fds[(vq /2)], VHOST_SET_VRING_CALL, &file);
 if (r < 0)
 die_perror("VHOST_SET_VRING_CALL failed");
+
 file.fd = ndev->tap_fd;
-r = ioctl(ndev->vhost_fd, VHOST_NET_SET_BACKEND, &file);
+r = ioctl(ndev->vhost_fds[(vq /2)], VHOST_NET_SET_BACKEND, &file);
 if (r != 0)
 die("VHOST_NET_SET_BACKEND failed %d", errno);
-
 }

 static void notify_vq_eventfd(struct kvm *kvm, void *dev, u32 vq, u32 efd)
 {
 struct net_dev *ndev = dev;
 struct vhost_vring_file file = {
-.index= vq,
+.index= vq % 2,
 .fd= efd,
 };
 int r;

-if (ndev->vhost_fd == 0 || is_ctrl_vq(ndev, vq))
+if (ndev->vhost_fd == 0 || is_ctrl_vq(ndev, vq)) {
 return;
+}
+r = ioctl(ndev->vhost_fds[(vq /2)], VHOST_SET_VRING_KICK, &file);

-r = ioctl(ndev->vhost_fd, VHOST_SET_VRING_KICK, &file);
 if (r < 0)
 die_perror("VHOST_SET_VRING_KICK failed");
 }
@@ -777,10 +788,6 @@ static void virtio_net__vhost_init(struct kvm *kvm, struct net_dev *ndev)
 struct vhost_memory *mem;
 int r, i;

-ndev->vhost_fd = open("/dev/vhost-net", O_RDWR);
-if (ndev->vhost_fd < 0)
-die_perror("Failed openning vhost-net device");
-
 mem = calloc(1, sizeof(*mem) + kvm->mem_slots * sizeof(struct vhost_memory_region));
 if (mem == NULL)
 die("Failed allocating memory for vhost memory map");
@@ -796,13 +803,22 @@ static void virtio_net__vhost_init(struct kvm *kvm, struct net_dev *ndev)
 }
 mem->nregions = i;

-r = ioctl(ndev->vhost_fd, VHOST_SET_OWNER);
-if (r != 0)
-die_perror("VHOST_SET_OWNER failed");
+for (i = 0 ; (i < (int)ndev->queue_pairs) &&
+(i < VIRTIO_NET_NUM_QUEUES) ; i++) {

-r = ioctl(ndev->vhost_fd, VHOST_SET_MEM_TABLE, mem);
-if (r != 0)
-die_perror("VHOST_SET_MEM_TABLE failed");
+ndev->vhost_fds[i] = open("/dev/vhost-net", O_RDWR);
+if (ndev->vhost_fds[i] < 0)
+die_perror("Failed openning vhost-net device");
+
+r = ioctl(ndev->vhost_fds[i], VHOST_SET_OWNER);
+if (r != 0)
+die_perror("VHOST_SET_OWNER failed");
+
+r = ioctl(ndev->vhost_fds[i], VHOST_SET_MEM_TABLE, mem);
+if (r != 0)
+die_perror("VHOST_SET_MEM_TABLE failed");
+}
+ndev->vhost_fd = ndev->vhost_fds[0];

 ndev->vdev.use_vhost = true;

diff --git a/virtio/pci.c b/virtio/pci.c
index c652949..2c456df 100644
--- a/virtio/pci.c
+++ b/virtio/pci.c
@@ -44,7 +44,7 @@ static int virtio_pci__init_ioeventfd(struct kvm *kvm, struct virtio_device *vde
  * Vhost will poll the eventfd in host kernel side, otherwise we
  * need to poll in userspace.
  */
-if (!vdev->use_vhost)
+if (!vdev->use_vhost || (vdev->ops->get_vq_count(kvm, vpci->dev) == (int)vq + 1))
 flags |= IOEVENTFD_FLAG_USER_POLL;

 /* ioport */



The University of Edinburgh is a charitable body, registered in Scotland, with registration number SC005336.
